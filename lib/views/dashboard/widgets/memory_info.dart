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
    if (!mounted) return;
    
    try {
      final memory = await clashCore.getMemory();
      _memoryInfoStateNotifier.value = TrafficValue(value: memory);
    } catch (e) {
      // 忽略错误，保持当前值
    }
    
    if (!mounted) return;
    
    timer = Timer(const Duration(seconds: 2), _updateMemory);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: getWidgetHeight(1),
        child: CommonCard(
          info: Info(
            iconData: Icons.memory,
            label: appLocalizations.memoryInfo,
          ),
          onPressed: () {
            clashCore.requestGc();
          },
          child: Container(
            padding: baseInfoEdgeInsets.copyWith(top: 0),
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
                          const SizedBox(width: 8),
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
      ),
    );
  }
}