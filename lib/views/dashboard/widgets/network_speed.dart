import 'package:li_clash/common/common.dart';
import 'package:li_clash/models/models.dart';
import 'package:li_clash/providers/app.dart';
import 'package:li_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkSpeed extends StatelessWidget {
  const NetworkSpeed({super.key});

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

  static Traffic _getLastTraffic(List<Traffic> traffics) {
    if (traffics.isEmpty) return Traffic();
    return traffics.last;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme.onSurfaceVariant.opacity80;
    return SizedBox(
      height: getWidgetHeight(2),
      child: CommonCard(
        onPressed: () {},
        info: Info(
          label: appLocalizations.networkSpeed,
          iconData: Icons.speed_sharp,
        ),
        child: RepaintBoundary(
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
                      child: RepaintBoundary(
                        child: LineChart(
                          gradient: true,
                          color: Theme.of(context).colorScheme.primary,
                          points: _getPoints(traffics),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: const Offset(-16, -20),
                      child: Text(
                        _getLastTraffic(traffics).toSpeedText(),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: color,
                        ),
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
