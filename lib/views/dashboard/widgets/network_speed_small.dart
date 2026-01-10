import 'package:li_clash/common/common.dart';
import 'package:li_clash/models/models.dart';
import 'package:li_clash/providers/app.dart';
import 'package:li_clash/state.dart';
import 'package:li_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkSpeedSmall extends StatefulWidget {
  const NetworkSpeedSmall({super.key});

  @override
  State<NetworkSpeedSmall> createState() => _NetworkSpeedSmallState();
}

class _NetworkSpeedSmallState extends State<NetworkSpeedSmall> {
  List<Point> initPoints = const [Point(0, 0), Point(1, 0)];

  List<Point> _getPoints(List<Traffic> traffics) {
    List<Point> trafficPoints = traffics
        .toList()
        .asMap()
        .map(
          (index, e) => MapEntry(
            index,
            Point(
              (index + initPoints.length).toDouble(),
              e.speed.toDouble(),
            ),
          ),
        )
        .values
        .toList();

    return [...initPoints, ...trafficPoints];
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
                      padding: EdgeInsets.all(16).copyWith(
                        bottom: 0,
                        left: 0,
                        right: 0,
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
