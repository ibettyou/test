import 'package:li_clash/common/common.dart';
import 'package:li_clash/models/models.dart';
import 'package:li_clash/providers/app.dart';
import 'package:li_clash/state.dart';
import 'package:li_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkSpeedSmall extends StatelessWidget {
  const NetworkSpeedSmall({super.key});

  // 缓存为 const 常量
  static const _initPoints = [Point(0, 0), Point(1, 0)];

  static List<Point> _getPoints(List<Traffic> traffics) {
    if (traffics.isEmpty) return _initPoints;
    
    // 避免 toList() 不必要的复制
    final trafficPoints = List<Point>.generate(
      traffics.length,
      (index) => Point(
        (index + _initPoints.length).toDouble(),
        traffics[index].speed.toDouble(),
      ),
    );

    return [..._initPoints, ...trafficPoints];
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: getWidgetHeight(1),
        child: CommonCard(
          onPressed: () {
            globalState.openUrl('https://ispeedtest.appshub.cc');
          },
          info: Info(
            label: appLocalizations.networkSpeed,
            iconData: Icons.speed_sharp,
          ),
          child: Consumer(
            builder: (_, ref, __) {
              final traffics = ref.watch(trafficsProvider).list;
              return Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 0,
                        right: 0,
                        bottom: 0,
                      ),
                      child: LineChart(
                        gradient: true,
                        color: Theme.of(context).colorScheme.primary,
                        points: _getPoints(traffics),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
