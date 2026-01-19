import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:li_clash/plugins/app.dart';
import 'package:li_clash/plugins/tile.dart';
import 'package:li_clash/plugins/vpn.dart';
import 'package:li_clash/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'application.dart';
import 'clash/core.dart';
import 'clash/lib.dart';
import 'common/common.dart';
import 'models/models.dart';

// Sentry DSN从环境变量获取，编译时替换
const String? _sentryDsn = String.fromEnvironment(
  'SENTRY_DSN',
  defaultValue: '',
);

Future<void> main() async {
  // 初始化基础服务
  globalState.isService = false;
  WidgetsFlutterBinding.ensureInitialized();
  final version = await system.version;
  await clashCore.preload();
  await globalState.initApp(version);
  
  // 检查用户是否启用崩溃分析
  final enableCrashReport = globalState.config.appSetting.enableCrashReport;
  
  if (enableCrashReport && _sentryDsn != null && _sentryDsn!.isNotEmpty) {
    // 启用Sentry
    await SentryFlutter.init(
      (options) {
        options.dsn = _sentryDsn;
        options.sendDefaultPii = true;
        // 设置环境信息
        options.environment = 'production';
        options.release = globalState.config.appSetting.toString();
      },
      appRunner: () => _runApp(version),
    );
  } else {
    // 不启用Sentry，直接运行
    await _runApp(version);
  }
}

Future<void> _runApp(int version) async {
  await android?.init();
  await window?.init(version);
  HttpOverrides.global = LiClashHttpOverrides();
  runApp(ProviderScope(
    child: const Application(),
  ));
}

@pragma('vm:entry-point')
Future<void> _service(List<String> flags) async {
  globalState.isService = true;
  WidgetsFlutterBinding.ensureInitialized();
  final quickStart = flags.contains('quick');
  final clashLibHandler = ClashLibHandler();
  await globalState.init();

  tile?.addListener(
    _TileListenerWithService(
      onStop: () async {
        await app?.tip(appLocalizations.stopVpn);
        clashLibHandler.stopListener();
        await vpn?.stop();
        exit(0);
      },
    ),
  );

  vpn?.handleGetStartForegroundParams = () async {
    // Check if smart-stopped from native side
    final isSmartStopped = await vpn?.isSmartStopped() ?? false;
    if (isSmartStopped) {
      return json.encode({
        'title': clashLibHandler.getCurrentProfileName(),
        'content': appLocalizations.smartAutoStopServiceRunning
      });
    }
    final traffic = clashLibHandler.getTraffic();
    return json.encode({
      'title': clashLibHandler.getCurrentProfileName(),
      'content': '$traffic'
    });
  };

  vpn?.addListener(
    _VpnListenerWithService(
      onDnsChanged: (String dns) {
        clashLibHandler.updateDns(dns);
      },
    ),
  );
  if (!quickStart) {
    _handleMainIpc(clashLibHandler);
  } else {
    commonPrint.log('quick start');
    await ClashCore.initGeo();
    app?.tip(appLocalizations.startVpn);
    final homeDirPath = await appPath.homeDirPath;
    final version = await system.version;
    final clashConfig = globalState.config.patchClashConfig.copyWith.tun(
      enable: false,
    );
    Future(() async {
      final profileId = globalState.config.currentProfileId;
      if (profileId == null) {
        return;
      }
      final params = await globalState.getSetupParams(
        pathConfig: clashConfig,
      );
      final res = await clashLibHandler.quickStart(
        InitParams(
          homeDir: homeDirPath,
          version: version,
        ),
        params,
        globalState.getCoreState(),
      );
      debugPrint(res);
      if (res.isNotEmpty) {
        await vpn?.stop();
        exit(0);
      }
      await vpn?.start(
        clashLibHandler.getAndroidVpnOptions(),
      );
      clashLibHandler.startListener();
    });
  }
}

void _handleMainIpc(ClashLibHandler clashLibHandler) {
  final sendPort = IsolateNameServer.lookupPortByName(mainIsolate);
  if (sendPort == null) {
    return;
  }
  final serviceReceiverPort = ReceivePort();
  serviceReceiverPort.listen((message) async {
    final res = await clashLibHandler.invokeAction(message);
    sendPort.send(res);
  });
  sendPort.send(serviceReceiverPort.sendPort);
  final messageReceiverPort = ReceivePort();
  clashLibHandler.attachMessagePort(
    messageReceiverPort.sendPort.nativePort,
  );
  messageReceiverPort.listen((message) {
    sendPort.send(message);
  });
}

@immutable
class _TileListenerWithService with TileListener {
  final Function() _onStop;

  const _TileListenerWithService({
    required Function() onStop,
  }) : _onStop = onStop;

  @override
  void onStop() {
    _onStop();
  }
}

@immutable
class _VpnListenerWithService with VpnListener {
  final Function(String dns) _onDnsChanged;

  const _VpnListenerWithService({
    required Function(String dns) onDnsChanged,
  }) : _onDnsChanged = onDnsChanged;

  @override
  void onDnsChanged(String dns) {
    super.onDnsChanged(dns);
    _onDnsChanged(dns);
  }
}
