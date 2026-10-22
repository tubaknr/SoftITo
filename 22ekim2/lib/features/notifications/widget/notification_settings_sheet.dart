import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/notifications_controller.dart';
import '../models/notification_settings.dart';

/// Modal sheet to customize notification preferences
class NotificationSettingsSheet extends StatelessWidget {
  const NotificationSettingsSheet({super.key, required this.controller});

  final NotificationsController controller;

  static Future<void> show(
    BuildContext context, {
    required NotificationsController controller,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => NotificationSettingsSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NotificationSettings>(
      valueListenable: controller.settings,
      builder: (context, current, _) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: context.padding.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDragHandle(context),
                const SizedBox(height: 12),
                _buildTitle(context),
                const SizedBox(height: 16),
                _buildSuccessItem(context, current),
                _buildDivider(context),
                _buildMotivationItem(context, current),
                _buildDivider(context),
                _buildMissedDayItem(context, current),
                _buildDivider(context),
                _buildDaytimeReminderItem(context, current),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 5,
        decoration: BoxDecoration(
          color: context.colors.borderLight,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      context.loc.notificationSettingsTitle,
      style: context.typography.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: context.colors.textMain,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(color: context.colors.borderLight, height: 24);
  }

  Widget _buildSuccessItem(BuildContext context, NotificationSettings current) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(
        context.loc.notifSuccessTitle,
        style: context.typography.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colors.textMain,
        ),
      ),
      subtitle: Text(
        context.loc.notifSuccessDesc,
        style: context.typography.bodySmall?.copyWith(
          color: context.colors.textMuted,
        ),
      ),
      value: current.successNotificationsEnabled,
      activeTrackColor: context.colors.primary,
      onChanged: (val) {
        controller.updateSettings(
          current.copyWith(successNotificationsEnabled: val),
        );
      },
    );
  }

  Widget _buildMotivationItem(BuildContext context, NotificationSettings current) {
    return Column(
      children: [
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: Text(
            context.loc.notifMotivationTitle,
            style: context.typography.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.textMain,
            ),
          ),
          subtitle: Text(
            context.loc.notifMotivationDesc,
            style: context.typography.bodySmall?.copyWith(
              color: context.colors.textMuted,
            ),
          ),
          value: current.dailyMotivationEnabled,
          activeTrackColor: context.colors.primary,
          onChanged: (val) {
            controller.updateSettings(
              current.copyWith(dailyMotivationEnabled: val),
            );
          },
        ),
        if (current.dailyMotivationEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saat: ${current.motivationHour.toString().padLeft(2, '0')}:${current.motivationMinute.toString().padLeft(2, '0')}',
                  style: context.typography.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colors.primary,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: current.motivationHour,
                        minute: current.motivationMinute,
                      ),
                    );
                    if (picked != null) {
                      controller.updateSettings(
                        current.copyWith(
                          motivationHour: picked.hour,
                          motivationMinute: picked.minute,
                        ),
                      );
                    }
                  },
                  child: const Text('Değiştir'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMissedDayItem(BuildContext context, NotificationSettings current) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(
        context.loc.notifMissedTitle,
        style: context.typography.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colors.textMain,
        ),
      ),
      subtitle: Text(
        context.loc.notifMissedDesc,
        style: context.typography.bodySmall?.copyWith(
          color: context.colors.textMuted,
        ),
      ),
      value: current.missedDayWarningEnabled,
      activeTrackColor: context.colors.primary,
      onChanged: (val) {
        controller.updateSettings(
          current.copyWith(missedDayWarningEnabled: val),
        );
      },
    );
  }

  Widget _buildDaytimeReminderItem(
    BuildContext context,
    NotificationSettings current,
  ) {
    return Column(
      children: [
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: Text(
            context.loc.notifRemindersTitle,
            style: context.typography.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.textMain,
            ),
          ),
          subtitle: Text(
            context.loc.notifRemindersDesc,
            style: context.typography.bodySmall?.copyWith(
              color: context.colors.textMuted,
            ),
          ),
          value: current.daytimeRemindersEnabled,
          activeTrackColor: context.colors.primary,
          onChanged: (val) {
            controller.updateSettings(
              current.copyWith(daytimeRemindersEnabled: val),
            );
          },
        ),
        if (current.daytimeRemindersEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.loc.notifFrequency}: ${current.daytimeReminderIntervalHours} ${context.loc.hourUnit}',
                  style: context.typography.bodySmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                DropdownButton<int>(
                  value: current.daytimeReminderIntervalHours,
                  dropdownColor: context.colors.bgCard,
                  items: [1, 2, 3, 4, 6].map((h) {
                    return DropdownMenuItem(value: h, child: Text('$h h'));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.updateSettings(
                        current.copyWith(daytimeReminderIntervalHours: val),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
