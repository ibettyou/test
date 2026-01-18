import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:li_clash/common/common.dart';

/// Sentry DSN (从环境变量或编译时常量获取)
const String _sentryDsn = String.fromEnvironment(
  'SENTRY_DSN',
  defaultValue: '',
);

/// 初始化 Sentry 崩溃分析
Future<void> initSentry({
  required bool enabled,
  required Future<void> Function() appRunner,
}) async {
  // 如果未启用或DSN为空，直接运行应用
  if (!enabled || _sentryDsn.isEmpty) {
    await appRunner();
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = _sentryDsn;
      
      // 只在Release模式下启用
      options.enabled = kReleaseMode && enabled;
      
      // 设置环境
      options.environment = kReleaseMode ? 'production' : 'development';
      
      // 设置采样率（只收集一部分崩溃，降低服务器压力）
      options.sampleRate = 1.0; // 100%收集崩溃
      
      // 禁用性能监控（只需要崩溃分析）
      options.enableAutoPerformanceTracing = false;
      options.tracesSampleRate = 0.0;
      
      // 禁用自动会话跟踪
      options.enableAutoSessionTracking = false;
      
      // 禁用用户交互跟踪
      options.enableUserInteractionTracing = false;
      
      // 禁用应用未响应跟踪
      options.enableAppHangTracking = false;
      
      // 设置发布版本
      try {
        options.release = 'li_clash@${system.packageInfo.version}+${system.packageInfo.buildNumber}';
      } catch (_) {
        // 如果获取版本失败，使用默认值
      }
      
      // 只发送崩溃和错误，不发送日志
      options.beforeSend = (event, {hint}) {
        // 只发送异常和错误事件
        if (event.level == SentryLevel.fatal || 
            event.level == SentryLevel.error) {
          return event;
        }
        return null;
      };
      
      // 添加平台信息
      options.addInAppInclude('li_clash');
      
      // 设置附件处理器（可选，用于附加额外日志）
      options.attachStacktrace = true;
    },
    appRunner: appRunner,
  );
}

/// 根据用户设置动态启用/禁用 Sentry
Future<void> updateSentryStatus(bool enabled) async {
  if (_sentryDsn.isEmpty) return;
  
  final hub = Sentry.currentHub;
  if (enabled) {
    // 启用 Sentry
    await hub.getOptions()?.then((options) {
      if (options != null) {
        options.enabled = kReleaseMode;
      }
    });
  } else {
    // 禁用 Sentry
    await hub.getOptions()?.then((options) {
      if (options != null) {
        options.enabled = false;
      }
    });
    // 清除当前会话
    await Sentry.close();
  }
}
