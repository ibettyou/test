import 'package:li_clash/common/common.dart';
import 'package:li_clash/providers/config.dart';
import 'package:li_clash/widgets/widgets.dart';
import 'package:li_clash/sentry_config.dart' as sentry;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CloseConnectionsItem extends ConsumerWidget {
  const CloseConnectionsItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final closeConnections = ref.watch(
      appSettingProvider.select((state) => state.closeConnections),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.autoCloseConnections),
      subtitle: Text(appLocalizations.autoCloseConnectionsDesc),
      delegate: SwitchDelegate(
        value: closeConnections,
        onChanged: (value) async {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(
                  closeConnections: value,
                ),
              );
        },
      ),
    );
  }
}

class UsageItem extends ConsumerWidget {
  const UsageItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final onlyStatisticsProxy = ref.watch(
      appSettingProvider.select((state) => state.onlyStatisticsProxy),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.onlyStatisticsProxy),
      subtitle: Text(appLocalizations.onlyStatisticsProxyDesc),
      delegate: SwitchDelegate(
        value: onlyStatisticsProxy,
        onChanged: (bool value) async {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(
                  onlyStatisticsProxy: value,
                ),
              );
        },
      ),
    );
  }
}

class AutoLaunchItem extends ConsumerWidget {
  const AutoLaunchItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoLaunch = ref.watch(
      appSettingProvider.select((state) => state.autoLaunch),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.autoLaunch),
      subtitle: Text(appLocalizations.autoLaunchDesc),
      delegate: SwitchDelegate(
        value: autoLaunch,
        onChanged: (bool value) {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(
                  autoLaunch: value,
                ),
              );
        },
      ),
    );
  }
}

class SilentLaunchItem extends ConsumerWidget {
  const SilentLaunchItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final silentLaunch = ref.watch(
      appSettingProvider.select((state) => state.silentLaunch),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.silentLaunch),
      subtitle: Text(appLocalizations.silentLaunchDesc),
      delegate: SwitchDelegate(
        value: silentLaunch,
        onChanged: (bool value) {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(
                  silentLaunch: value,
                ),
              );
        },
      ),
    );
  }
}

class AutoRunItem extends ConsumerWidget {
  const AutoRunItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoRun = ref.watch(
      appSettingProvider.select((state) => state.autoRun),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.autoRun),
      subtitle: Text(appLocalizations.autoRunDesc),
      delegate: SwitchDelegate(
        value: autoRun,
        onChanged: (bool value) {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(
                  autoRun: value,
                ),
              );
        },
      ),
    );
  }
}

class HiddenItem extends ConsumerWidget {
  const HiddenItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hidden = ref.watch(
      appSettingProvider.select((state) => state.hidden),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.exclude),
      subtitle: Text(appLocalizations.excludeDesc),
      delegate: SwitchDelegate(
        value: hidden,
        onChanged: (value) {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(
                  hidden: value,
                ),
              );
        },
      ),
    );
  }
}

class AnimateTabItem extends ConsumerWidget {
  const AnimateTabItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnimateToPage = ref.watch(
      appSettingProvider.select((state) => state.isAnimateToPage),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.tabAnimation),
      subtitle: Text(appLocalizations.tabAnimationDesc),
      delegate: SwitchDelegate(
        value: isAnimateToPage,
        onChanged: (value) {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(
                  isAnimateToPage: value,
                ),
              );
        },
      ),
    );
  }
}

class OpenLogsItem extends ConsumerWidget {
  const OpenLogsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openLogs = ref.watch(
      appSettingProvider.select((state) => state.openLogs),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.logcat),
      subtitle: Text(appLocalizations.logcatDesc),
      delegate: SwitchDelegate(
        value: openLogs,
        onChanged: (bool value) {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(
                  openLogs: value,
                ),
              );
        },
      ),
    );
  }
}


class CrashAnalyticsItem extends ConsumerWidget {
  const CrashAnalyticsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableCrashAnalytics = ref.watch(
      appSettingProvider.select((state) => state.enableCrashAnalytics),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.crashAnalytics),
      subtitle: Text(appLocalizations.crashAnalyticsDesc),
      delegate: SwitchDelegate(
        value: enableCrashAnalytics,
        onChanged: (bool value) async {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(
                  enableCrashAnalytics: value,
                ),
              );
          // 动态更新 Sentry 状态
          try {
            await sentry.updateSentryStatus(value);
          } catch (e) {
            // 如果更新失败，静默处理（下次重启时会生效）
          }
        },
      ),
    );
  }
}

class AutoCheckUpdateItem extends ConsumerWidget {
  const AutoCheckUpdateItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoCheckUpdate = ref.watch(
      appSettingProvider.select((state) => state.autoCheckUpdate),
    );
    return ListItem.switchItem(
      title: Text(appLocalizations.autoCheckUpdate),
      subtitle: Text(appLocalizations.autoCheckUpdateDesc),
      delegate: SwitchDelegate(
        value: autoCheckUpdate,
        onChanged: (bool value) {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(
                  autoCheckUpdate: value,
                ),
              );
        },
      ),
    );
  }
}

class ApplicationSettingView extends StatelessWidget {
  const ApplicationSettingView({super.key});

  String getLocaleString(Locale? locale) {
    if (locale == null) return appLocalizations.defaultText;
    return Intl.message(locale.toString());
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      if (system.isDesktop) ...[
        AutoLaunchItem(),
        SilentLaunchItem(),
      ],
      AutoRunItem(),
      if (system.isAndroid) ...[
        HiddenItem(),
      ],
      AnimateTabItem(),
      OpenLogsItem(),
      CloseConnectionsItem(),
      UsageItem(),
      CrashAnalyticsItem(),
      AutoCheckUpdateItem(),
    ];
    return ListView.separated(
      itemBuilder: (_, index) {
        final item = items[index];
        return item;
      },
      separatorBuilder: (_, __) {
        return const Divider(
          height: 0,
        );
      },
      itemCount: items.length,
    );
  }
}
