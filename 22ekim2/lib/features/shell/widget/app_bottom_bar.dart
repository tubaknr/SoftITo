import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/shell_controller.dart';

/// Floating glassmorphic 4-tab bottom navigation bar
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({super.key, required this.controller});

  final ShellController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ValueListenableBuilder<int>(
      valueListenable: controller,
      builder: (context, activeIndex, _) {
        return Container(
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: context.padding.bottom > 0 ? context.padding.bottom : 16,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: colors.bgCard.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: colors.borderLight.withValues(alpha: 0.7)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(
                context: context,
                index: 0,
                active: activeIndex == 0,
                icon: Icons.home_rounded,
                label: context.loc.tabHome,
              ),
              _buildTabItem(
                context: context,
                index: 1,
                active: activeIndex == 1,
                icon: Icons.calendar_month_rounded,
                label: context.loc.tabCalendar,
              ),
              _buildTabItem(
                context: context,
                index: 2,
                active: activeIndex == 2,
                icon: Icons.bar_chart_rounded,
                label: context.loc.tabAnalytics,
              ),
              _buildTabItem(
                context: context,
                index: 3,
                active: activeIndex == 3,
                icon: Icons.person_rounded,
                label: context.loc.tabProfile,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required int index,
    required bool active,
    required IconData icon,
    required String label,
  }) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () => controller.setTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? colors.primary.withValues(alpha: 0.14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: active ? colors.primary : colors.textMuted,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: context.typography.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? colors.primary : colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
