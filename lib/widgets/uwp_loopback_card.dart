import 'dart:io';
import 'package:flutter/material.dart';
import 'uwp_loopback_dialog.dart';
import '../common/modern_feature_card.dart';
import '../widgets/modern_tooltip.dart';

// UWP 回环管理卡片（仅 Windows 平台显示）。
class UwpLoopbackCard extends StatelessWidget {
  const UwpLoopbackCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 仅在 Windows 平台显示
    if (!Platform.isWindows) {
      return const SizedBox.shrink();
    }

    return ModernFeatureLayoutCard(
      icon: Icons.apps,
      title: 'UWP Loopback Manager',
      subtitle: 'Manage loopback exemptions for UWP applications',
      trailing: ModernTooltip(
        message: 'Open UWP Loopback Manager',
        child: IconButton(
          icon: const Icon(Icons.open_in_new),
          onPressed: () {
            UwpLoopbackDialog.show(context);
          },
        ),
      ),
      isHoverEnabled: true,
      isTapEnabled: false,
    );
  }
}