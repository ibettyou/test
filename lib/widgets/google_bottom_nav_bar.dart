import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:li_clash/common/common.dart';
import 'package:li_clash/models/common.dart';
import 'package:intl/intl.dart';

class GoogleBottomNavBar extends StatelessWidget {
  final List<NavigationItem> navigationItems;
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const GoogleBottomNavBar({
    super.key,
    required this.navigationItems,
    required this.selectedIndex,
    required this.onTabChange,
  });

  IconData _extractIconData(Widget iconWidget) {
    if (iconWidget is Icon) {
      return iconWidget.icon ?? Icons.home;
    }
    return Icons.home;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withValues(alpha: 0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            rippleColor: context.colorScheme.onSurface.withValues(alpha: 0.15),
            hoverColor: context.colorScheme.onSurface.withValues(alpha: 0.1),
            gap: 8,
            activeColor: context.colorScheme.onSecondaryContainer,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 260),
            tabBackgroundColor: context.colorScheme.secondaryContainer,
            color: context.colorScheme.onSurfaceVariant,
            curve: Curves.easeOutExpo,
            tabs: navigationItems
                .map(
                  (e) => GButton(
                    icon: _extractIconData(e.icon),
                    text: Intl.message(e.label.name),
                  ),
                )
                .toList(),
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}
