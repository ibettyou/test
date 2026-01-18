import 'dart:async';
import 'package:li_clash/common/common.dart';
import 'package:li_clash/enum/enum.dart';
import 'package:li_clash/models/models.dart';
import 'package:li_clash/providers/providers.dart';
import 'package:li_clash/state.dart';
import 'package:li_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartButton extends ConsumerWidget {
  const StartButton({super.key});

  void _handleStart(WidgetRef ref) {
    final isStart = ref.read(runTimeProvider) != null;
    final newState = !isStart;

    debouncer.call(
      FunctionTag.updateStatus,
      () {
        globalState.appController.updateStatus(newState);
      },
      duration: commonDuration,
    );
  }

  static String _formatRunTime(int? timeStamp) {
    if (timeStamp == null) return '00:00:00';

    final diff = timeStamp / 1000;
    int inHours = (diff / 3600).floor();
    int inMinutes = (diff / 60 % 60).floor();
    int inSeconds = (diff % 60).floor();

    // Limit maximum display to 999:59:59
    if (inHours > 999) {
      inHours = 999;
      inMinutes = 59;
      inSeconds = 59;
    }

    // If less than 100 hours, show 2 digits; otherwise 3
    final hourStr = inHours < 100
        ? inHours.toString().padLeft(2, '0')
        : inHours.toString().padLeft(3, '0');

    return '$hourStr:${inMinutes.toString().padLeft(2, '0')}:${inSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(startButtonSelectorStateProvider);
    final runTime = ref.watch(runTimeProvider);
    final isStart = runTime != null;

    return RepaintBoundary(
      child: SizedBox(
        height: getWidgetHeight(1),
        child: CommonCard(
          info: Info(
            label: isStart
                ? appLocalizations.runTime
                : appLocalizations.powerSwitch,
            iconData: Icons.power_settings_new,
          ),
          onPressed: state.isInit && state.hasProfile ? () => _handleStart(ref) : null,
          child: Container(
            padding: baseInfoEdgeInsets.copyWith(top: 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: globalState.measure.bodyMediumHeight + 2,
                  child: _buildContent(context, state, isStart, runTime),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    StartButtonSelectorState state,
    bool isStart,
    int? runTime,
  ) {
    if (!state.isInit) {
      return Container(
        padding: const EdgeInsets.all(2),
        child: const AspectRatio(
          aspectRatio: 1,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (!state.hasProfile) {
      return Text(
        appLocalizations.checkOrAddProfile,
        style: context.textTheme.bodyMedium?.toLight.adjustSize(1),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    if (!isStart) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.play_arrow,
            size: 16,
            color: context.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              appLocalizations.serviceReady,
              style: context.textTheme.bodyMedium?.toLight.adjustSize(1),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    // Started state: show pause icon + run time
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.pause,
          size: 16,
          color: context.colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text('  ', style: context.textTheme.bodyMedium?.toLight.adjustSize(1)),
        Expanded(
          child: Text(
            _formatRunTime(runTime),
            style: context.textTheme.bodyMedium?.toLight.adjustSize(1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
