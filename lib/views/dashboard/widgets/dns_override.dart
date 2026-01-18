import 'package:li_clash/common/common.dart';
import 'package:li_clash/providers/config.dart';
import 'package:li_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DnsOverride extends StatelessWidget {
  const DnsOverride({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: getWidgetHeight(1),
        child: CommonCard(
          info: Info(
            label: 'DNS',
            iconData: Icons.dns,
          ),
          onPressed: () {},
          child: Container(
            padding: baseInfoEdgeInsets.copyWith(
              top: 4,
              bottom: 8,
              right: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: TooltipText(
                    text: Text(
                      appLocalizations.override,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.adjustSize(-2)
                          .toLight,
                    ),
                  ),
                ),
                Consumer(
                  builder: (_, ref, __) {
                    final override = ref.watch(overrideDnsProvider);
                    return Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: override,
                      onChanged: (value) {
                        ref.read(overrideDnsProvider.notifier).value = value;
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
