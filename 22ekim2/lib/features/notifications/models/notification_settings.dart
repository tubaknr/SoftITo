/// Immutable notification settings model
class NotificationSettings {
  const NotificationSettings({
    this.successNotificationsEnabled = true,
    this.dailyMotivationEnabled = true,
    this.motivationHour = 9,
    this.motivationMinute = 0,
    this.missedDayWarningEnabled = true,
    this.daytimeRemindersEnabled = false,
    this.daytimeReminderIntervalHours = 3,
  });

  final bool successNotificationsEnabled;
  final bool dailyMotivationEnabled;
  final int motivationHour;
  final int motivationMinute;
  final bool missedDayWarningEnabled;
  final bool daytimeRemindersEnabled;
  final int daytimeReminderIntervalHours;

  NotificationSettings copyWith({
    bool? successNotificationsEnabled,
    bool? dailyMotivationEnabled,
    int? motivationHour,
    int? motivationMinute,
    bool? missedDayWarningEnabled,
    bool? daytimeRemindersEnabled,
    int? daytimeReminderIntervalHours,
  }) {
    return NotificationSettings(
      successNotificationsEnabled:
          successNotificationsEnabled ?? this.successNotificationsEnabled,
      dailyMotivationEnabled:
          dailyMotivationEnabled ?? this.dailyMotivationEnabled,
      motivationHour: motivationHour ?? this.motivationHour,
      motivationMinute: motivationMinute ?? this.motivationMinute,
      missedDayWarningEnabled:
          missedDayWarningEnabled ?? this.missedDayWarningEnabled,
      daytimeRemindersEnabled:
          daytimeRemindersEnabled ?? this.daytimeRemindersEnabled,
      daytimeReminderIntervalHours:
          daytimeReminderIntervalHours ?? this.daytimeReminderIntervalHours,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'successNotificationsEnabled': successNotificationsEnabled,
      'dailyMotivationEnabled': dailyMotivationEnabled,
      'motivationHour': motivationHour,
      'motivationMinute': motivationMinute,
      'missedDayWarningEnabled': missedDayWarningEnabled,
      'daytimeRemindersEnabled': daytimeRemindersEnabled,
      'daytimeReminderIntervalHours': daytimeReminderIntervalHours,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      successNotificationsEnabled:
          (json['successNotificationsEnabled'] as bool?) ?? true,
      dailyMotivationEnabled:
          (json['dailyMotivationEnabled'] as bool?) ?? true,
      motivationHour: (json['motivationHour'] as int?) ?? 9,
      motivationMinute: (json['motivationMinute'] as int?) ?? 0,
      missedDayWarningEnabled:
          (json['missedDayWarningEnabled'] as bool?) ?? true,
      daytimeRemindersEnabled:
          (json['daytimeRemindersEnabled'] as bool?) ?? false,
      daytimeReminderIntervalHours:
          (json['daytimeReminderIntervalHours'] as int?) ?? 3,
    );
  }
}
