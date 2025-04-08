import 'package:flutter/material.dart';

class SleepSchedule {
  final String? id;
  final String userId;
  final TimeOfDay bedTime;
  final TimeOfDay wakeTime;
  final bool bedtimeReminderEnabled;
  final bool wakeupReminderEnabled;
  final String bedtimeReminderMessage;
  final String wakeupReminderMessage;
  final bool isScheduleActive;
  final String? createdAt;
  final String? updatedAt;

  SleepSchedule({
    this.id,
    required this.userId,
    required this.bedTime,
    required this.wakeTime,
    this.bedtimeReminderEnabled = false,
    this.wakeupReminderEnabled = false,
    this.bedtimeReminderMessage = "Time to sleep! Rest well for tomorrow.",
    this.wakeupReminderMessage = "Good morning! Time to start your day.",
    this.isScheduleActive = false,
    this.createdAt,
    this.updatedAt,
  });

  // Convert TimeOfDay to string in format "HH:MM"
  static String timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Convert string in format "HH:MM" to TimeOfDay
  static TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // Convert SleepSchedule to Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'bedTime': timeOfDayToString(bedTime),
      'wakeTime': timeOfDayToString(wakeTime),
      'bedtimeReminderEnabled': bedtimeReminderEnabled,
      'wakeupReminderEnabled': wakeupReminderEnabled,
      'bedtimeReminderMessage': bedtimeReminderMessage,
      'wakeupReminderMessage': wakeupReminderMessage,
      'isScheduleActive': isScheduleActive,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  // Create SleepSchedule from Map
  factory SleepSchedule.fromMap(Map<String, dynamic> map) {
    return SleepSchedule(
      id: map['id'],
      userId: map['userId'],
      bedTime: stringToTimeOfDay(map['bedTime']),
      wakeTime: stringToTimeOfDay(map['wakeTime']),
      bedtimeReminderEnabled: map['bedtimeReminderEnabled'] ?? false,
      wakeupReminderEnabled: map['wakeupReminderEnabled'] ?? false,
      bedtimeReminderMessage: map['bedtimeReminderMessage'] ?? "Time to sleep! Rest well for tomorrow.",
      wakeupReminderMessage: map['wakeupReminderMessage'] ?? "Good morning! Time to start your day.",
      isScheduleActive: map['isScheduleActive'] ?? false,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  // Calculate sleep duration in hours
  double get sleepDuration {
    double bedHours = bedTime.hour + bedTime.minute / 60.0;
    double wakeHours = wakeTime.hour + wakeTime.minute / 60.0;

    // Handle overnight sleep (e.g., 10 PM to 5 AM)
    if (wakeHours < bedHours) {
      return (24 - bedHours) + wakeHours;
    } else {
      return wakeHours - bedHours;
    }
  }

  // Create a copy with updated fields
  SleepSchedule copyWith({
    String? id,
    String? userId,
    TimeOfDay? bedTime,
    TimeOfDay? wakeTime,
    bool? bedtimeReminderEnabled,
    bool? wakeupReminderEnabled,
    String? bedtimeReminderMessage,
    String? wakeupReminderMessage,
    bool? isScheduleActive,
    String? createdAt,
    String? updatedAt,
  }) {
    return SleepSchedule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bedTime: bedTime ?? this.bedTime,
      wakeTime: wakeTime ?? this.wakeTime,
      bedtimeReminderEnabled: bedtimeReminderEnabled ?? this.bedtimeReminderEnabled,
      wakeupReminderEnabled: wakeupReminderEnabled ?? this.wakeupReminderEnabled,
      bedtimeReminderMessage: bedtimeReminderMessage ?? this.bedtimeReminderMessage,
      wakeupReminderMessage: wakeupReminderMessage ?? this.wakeupReminderMessage,
      isScheduleActive: isScheduleActive ?? this.isScheduleActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
