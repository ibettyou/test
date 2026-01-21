import 'dart:async';
import 'dart:io';

import 'package:li_clash/clash/clash.dart';
import 'package:li_clash/common/common.dart';
import 'package:li_clash/models/common.dart';
import 'package:li_clash/state.dart';
import 'package:li_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';

final _memoryInfoStateNotifier = ValueNotifier<TrafficValue>(
  TrafficValue(value: 0),
);

class MemoryInfo extends StatefulWidget {
  const MemoryInfo({super.key});

  @override
  State<MemoryInfo> createState() => _MemoryInfoState();
}

class _MemoryInfoState extends State<MemoryInfo> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _updateMemory();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _updateMemory() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // final rss = ProcessInfo.currentRss;
      _memoryInfoStateNotifier.value = TrafficValue(
        value: await clashCore.getMemory(),
      );
      timer = Timer(Duration(seconds: 2), () async {
        _updateMemory();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getWidgetHeight(1),
      child: CommonCard(
        info: Info(
          iconData: Icons.memory,
          label: appLocalizations.memoryInfo,
        ),
        onPressed: () async {
          // 显示确认对话框
          final result = await globalState.showCommonDialog<bool>(
            child: CommonDialog(
              title: appLocalizations.forceGCTitle,
              child: Text(appLocalizations.forceGCDesc),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(appLocalizations.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(appLocalizations.confirm),
                ),
              ],
            ),
          );
          
          // 用户确认后，在新的微任务中执行GC
          if (result == true) {
            Future.delayed(Duration.zero, () async {
              try {
                await clashCore.requestGc();
                globalState.showNotifier(appLocalizations.forceGCTitle);
              } catch (e) {
                globalState.showNotifier('${appLocalizations.forceGCTitle}: $e');
              }
            });
          }
        },
        child: Container(
          padding: baseInfoEdgeInsets.copyWith(
            top: 0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: globalState.measure.bodyMediumHeight + 2,
                child: ValueListenableBuilder(
                  valueListenable: _memoryInfoStateNotifier,
                  builder: (_, trafficValue, __) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          trafficValue.showValue,
                          style: context.textTheme.bodyMedium?.toLight
                              .adjustSize(1),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          trafficValue.showUnit,
                          style: context.textTheme.bodyMedium?.toLight
                              .adjustSize(1),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}