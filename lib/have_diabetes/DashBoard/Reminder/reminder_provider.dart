// import 'package:flutter/material.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_model.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_service.dart';
//
// class ReminderProvider with ChangeNotifier {
//   final ReminderService _reminderService = ReminderService();
//   List<Reminder> _reminders = [];
//   bool _isLoading = false;
//   String? _error;
//
//   List<Reminder> get reminders => _reminders;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   ReminderProvider() {
//     loadReminders();
//   }
//
//   // 🔹 Load Reminders from Firestore
//   void loadReminders() {
//     _isLoading = true;
//     notifyListeners();
//
//     _reminderService.getReminders().listen(
//             (reminders) {
//           _reminders = reminders;
//           _isLoading = false;
//           _error = null;
//           notifyListeners();
//         },
//         onError: (error) {
//           _isLoading = false;
//           _error = "Failed to load reminders: ${error.toString()}";
//           notifyListeners();
//         }
//     );
//   }
//
//   // 🔹 Add Reminder
//   Future<bool> addReminder(Reminder reminder) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       await _reminderService.addReminder(reminder);
//       _isLoading = false;
//       _error = null;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       _error = "Failed to add reminder: ${e.toString()}";
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // 🔹 Update Reminder
//   Future<bool> updateReminder(Reminder reminder) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       await _reminderService.updateReminder(reminder);
//       _isLoading = false;
//       _error = null;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       _error = "Failed to update reminder: ${e.toString()}";
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // 🔹 Delete Reminder
//   Future<bool> deleteReminder(String id) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       await _reminderService.deleteReminder(id);
//       _isLoading = false;
//       _error = null;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       _error = "Failed to delete reminder: ${e.toString()}";
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // 🔹 Toggle Reminder Active Status
//   Future<bool> toggleReminderActive(String id, bool isActive) async {
//     try {
//       await _reminderService.toggleReminderActive(id, isActive);
//
//       // Update the local list
//       final index = _reminders.indexWhere((reminder) => reminder.id == id);
//       if (index != -1) {
//         _reminders[index] = _reminders[index].copyWith(isActive: isActive);
//         notifyListeners();
//       }
//
//       return true;
//     } catch (e) {
//       _error = "Failed to update reminder status: ${e.toString()}";
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // 🔹 Get a single reminder by ID
//   Future<Reminder?> getReminderById(String id) async {
//     try {
//       return await _reminderService.getReminderById(id);
//     } catch (e) {
//       _error = "Failed to get reminder: ${e.toString()}";
//       notifyListeners();
//       return null;
//     }
//   }
//
//   // 🔹 Clear error
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }
//
//

// import 'package:flutter/material.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_model.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// class ReminderProvider with ChangeNotifier {
//   final ReminderService _reminderService = ReminderService();
//   final FlutterLocalNotificationsPlugin _notificationsPlugin;
//   List<Reminder> _reminders = [];
//   bool _isLoading = false;
//   String? _error;
//
//   List<Reminder> get reminders => _reminders;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   ReminderProvider({required FlutterLocalNotificationsPlugin notificationsPlugin})
//       : _notificationsPlugin = notificationsPlugin {
//     loadReminders();
//   }
//
//   // 🔹 Load Reminders from Firestore
//   void loadReminders() {
//     _isLoading = true;
//     notifyListeners();
//
//     _reminderService.getReminders().listen(
//             (reminders) {
//           _reminders = reminders;
//           _isLoading = false;
//           _error = null;
//           notifyListeners();
//
//           // Schedule notifications for all active reminders
//           _scheduleNotificationsForAllReminders();
//         },
//         onError: (error) {
//           _isLoading = false;
//           _error = "Failed to load reminders: ${error.toString()}";
//           notifyListeners();
//         }
//     );
//   }
//
//   // 🔹 Add Reminder
//   Future<bool> addReminder(Reminder reminder) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       await _reminderService.addReminder(reminder);
//       _isLoading = false;
//       _error = null;
//       notifyListeners();
//
//       // Schedule notification for the new reminder
//       _scheduleNotificationForReminder(reminder);
//
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       _error = "Failed to add reminder: ${e.toString()}";
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // 🔹 Update Reminder
//   Future<bool> updateReminder(Reminder reminder) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       await _reminderService.updateReminder(reminder);
//       _isLoading = false;
//       _error = null;
//       notifyListeners();
//
//       // Cancel existing notification and schedule updated one
//       await _notificationsPlugin.cancel(reminder.id.hashCode);
//       _scheduleNotificationForReminder(reminder);
//
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       _error = "Failed to update reminder: ${e.toString()}";
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // 🔹 Delete Reminder
//   Future<bool> deleteReminder(String id) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       await _reminderService.deleteReminder(id);
//
//       // Cancel notification for the deleted reminder
//       await _notificationsPlugin.cancel(id.hashCode);
//
//       _isLoading = false;
//       _error = null;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       _error = "Failed to delete reminder: ${e.toString()}";
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // 🔹 Toggle Reminder Active Status
//   Future<bool> toggleReminderActive(String id, bool isActive) async {
//     try {
//       await _reminderService.toggleReminderActive(id, isActive);
//
//       // Update the local list
//       final index = _reminders.indexWhere((reminder) => reminder.id == id);
//       if (index != -1) {
//         _reminders[index] = _reminders[index].copyWith(isActive: isActive);
//
//         // Handle notification based on active status
//         if (isActive) {
//           _scheduleNotificationForReminder(_reminders[index]);
//         } else {
//           await _notificationsPlugin.cancel(id.hashCode);
//         }
//
//         notifyListeners();
//       }
//
//       return true;
//     } catch (e) {
//       _error = "Failed to update reminder status: ${e.toString()}";
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // 🔹 Get a single reminder by ID
//   Future<Reminder?> getReminderById(String id) async {
//     try {
//       return await _reminderService.getReminderById(id);
//     } catch (e) {
//       _error = "Failed to get reminder: ${e.toString()}";
//       notifyListeners();
//       return null;
//     }
//   }
//
//   // 🔹 Clear error
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
//
//   // 🔹 Schedule notifications for all active reminders
//   Future<void> _scheduleNotificationsForAllReminders() async {
//     // Cancel all existing notifications
//     await _notificationsPlugin.cancelAll();
//
//     // Schedule notifications for all active reminders
//     for (var reminder in _reminders) {
//       if (reminder.isActive) {
//         _scheduleNotificationForReminder(reminder);
//       }
//     }
//   }
//
//   // 🔹 Schedule notification for a single reminder
//   Future<void> _scheduleNotificationForReminder(Reminder reminder) async {
//     if (!reminder.isActive) return;
//
//     // Extract hour and minute from reminderTime
//     final hour = reminder.reminderTime.hour;
//     final minute = reminder.reminderTime.minute;
//
//     if (reminder.reminderType == 'one-time' && reminder.reminderDate != null) {
//       // Schedule one-time notification
//       final scheduledDate = DateTime(
//         reminder.reminderDate!.year,
//         reminder.reminderDate!.month,
//         reminder.reminderDate!.day,
//         hour,
//         minute,
//       );
//
//       // Only schedule if it's in the future
//       if (scheduledDate.isAfter(DateTime.now())) {
//         await _scheduleOneTimeNotification(
//           id: reminder.id.hashCode,
//           title: 'Diabetes App Reminder',
//           body: reminder.title,
//           scheduledDate: scheduledDate,
//         );
//       }
//     } else if (reminder.reminderType == 'repeat') {
//       if (reminder.repeatType == 'daily') {
//         // Schedule daily notification
//         await _scheduleDailyNotification(
//           id: reminder.id.hashCode,
//           title: 'Diabetes App Reminder',
//           body: reminder.title,
//           hour: hour,
//           minute: minute,
//         );
//       } else if (reminder.repeatType == 'custom' && reminder.startsOn != null) {
//         // Schedule custom notification
//         final startDate = DateTime(
//           reminder.startsOn!.year,
//           reminder.startsOn!.month,
//           reminder.startsOn!.day,
//           hour,
//           minute,
//         );
//
//         // Only schedule if start date is in the future or today
//         if (startDate.isAfter(DateTime.now()) ||
//             (startDate.year == DateTime.now().year &&
//                 startDate.month == DateTime.now().month &&
//                 startDate.day == DateTime.now().day)) {
//
//           await _scheduleDailyNotification(
//             id: reminder.id.hashCode,
//             title: 'Diabetes App Reminder',
//             body: reminder.title,
//             hour: hour,
//             minute: minute,
//             startDate: startDate,
//             endDate: reminder.neverEnds ? null : reminder.endsOn,
//           );
//         }
//       }
//     }
//   }
//
//   // 🔹 Schedule a one-time notification
//   Future<void> _scheduleOneTimeNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//   }) async {
//     final tzScheduledDate = tz.TZDateTime.from(
//       scheduledDate,
//       tz.local,
//     );
//
//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tzScheduledDate,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'diabetes_reminders',
//           'Diabetes Reminders',
//           channelDescription: 'Notifications for diabetes reminders',
//           importance: Importance.high,
//           priority: Priority.high,
//           sound: RawResourceAndroidNotificationSound('notification_sound'),
//         ),
//         iOS: DarwinNotificationDetails(
//           sound: 'notification_sound.aiff',
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//   // 🔹 Schedule a daily notification
//   Future<void> _scheduleDailyNotification({
//     required int id,
//     required String title,
//     required String body,
//     required int hour,
//     required int minute,
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     final now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//       tz.local,
//       startDate?.year ?? now.year,
//       startDate?.month ?? now.month,
//       startDate?.day ?? now.day,
//       hour,
//       minute,
//     );
//
//     // If the scheduled time is in the past, schedule for the next day
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//
//     // Check if the end date is specified and not passed
//     if (endDate != null) {
//       final tzEndDate = tz.TZDateTime(
//         tz.local,
//         endDate.year,
//         endDate.month,
//         endDate.day,
//         23,
//         59,
//         59,
//       );
//
//       if (scheduledDate.isAfter(tzEndDate)) {
//         return; // Don't schedule if beyond end date
//       }
//     }
//
//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledDate,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'diabetes_reminders',
//           'Diabetes Reminders',
//           channelDescription: 'Notifications for diabetes reminders',
//           importance: Importance.high,
//           priority: Priority.high,
//           sound: RawResourceAndroidNotificationSound('notification_sound'),
//         ),
//         iOS: DarwinNotificationDetails(
//           sound: 'notification_sound.aiff',
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       matchDateTimeComponents: DateTimeComponents.time,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_model.dart';
import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderProvider with ChangeNotifier {
  final ReminderService _reminderService = ReminderService();
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  List<Reminder> _reminders = [];
  bool _isLoading = false;
  String? _error;

  List<Reminder> get reminders => _reminders;

  bool get isLoading => _isLoading;

  String? get error => _error;

  ReminderProvider(
      {required FlutterLocalNotificationsPlugin notificationsPlugin})
      : _notificationsPlugin = notificationsPlugin {
    loadReminders();
  }

  // 🔹 Load Reminders from Firestore
  void loadReminders() {
    _isLoading = true;
    notifyListeners();

    _reminderService.getReminders().listen(
            (reminders) {
          _reminders = reminders;
          _isLoading = false;
          _error = null;
          notifyListeners();

          // Schedule notifications for all active reminders
          _scheduleNotificationsForAllReminders();
        },
        onError: (error) {
          _isLoading = false;
          _error = "Failed to load reminders: ${error.toString()}";
          print("Error in loadReminders: $_error");
          notifyListeners();
        }
    );
  }

  // 🔹 Add Reminder
  Future<bool> addReminder(Reminder reminder) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _reminderService.addReminder(reminder);
      _isLoading = false;
      _error = null;
      notifyListeners();

      // Schedule notification for the new reminder
      _scheduleNotificationForReminder(reminder);

      return true;
    } catch (e) {
      _isLoading = false;
      _error = "Failed to add reminder: ${e.toString()}";
      print("Error in addReminder: $_error");
      notifyListeners();
      return false;
    }
  }

  // 🔹 Update Reminder
  Future<bool> updateReminder(Reminder reminder) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _reminderService.updateReminder(reminder);
      _isLoading = false;
      _error = null;
      notifyListeners();

      // Cancel existing notification and schedule updated one
      await _notificationsPlugin.cancel(reminder.id.hashCode);
      _scheduleNotificationForReminder(reminder);

      return true;
    } catch (e) {
      _isLoading = false;
      _error = "Failed to update reminder: ${e.toString()}";
      print("Error in updateReminder: $_error");
      notifyListeners();
      return false;
    }
  }

  // 🔹 Delete Reminder
  Future<bool> deleteReminder(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _reminderService.deleteReminder(id);

      // Cancel notification for the deleted reminder
      await _notificationsPlugin.cancel(id.hashCode);

      _isLoading = false;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = "Failed to delete reminder: ${e.toString()}";
      print("Error in deleteReminder: $_error");
      notifyListeners();
      return false;
    }
  }

  // 🔹 Toggle Reminder Active Status
  Future<bool> toggleReminderActive(String id, bool isActive) async {
    try {
      await _reminderService.toggleReminderActive(id, isActive);

      // Update the local list
      final index = _reminders.indexWhere((reminder) => reminder.id == id);
      if (index != -1) {
        _reminders[index] = _reminders[index].copyWith(isActive: isActive);

        // Handle notification based on active status
        if (isActive) {
          _scheduleNotificationForReminder(_reminders[index]);
        } else {
          await _notificationsPlugin.cancel(id.hashCode);
        }

        notifyListeners();
      }

      return true;
    } catch (e) {
      _error = "Failed to update reminder status: ${e.toString()}";
      print("Error in toggleReminderActive: $_error");
      notifyListeners();
      return false;
    }
  }

  // 🔹 Get a single reminder by ID
  Future<Reminder?> getReminderById(String id) async {
    try {
      return await _reminderService.getReminderById(id);
    } catch (e) {
      _error = "Failed to get reminder: ${e.toString()}";
      print("Error in getReminderById: $_error");
      notifyListeners();
      return null;
    }
  }

  // 🔹 Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // 🔹 Schedule notifications for all active reminders
  Future<void> _scheduleNotificationsForAllReminders() async {
    try {
      // Cancel all existing notifications
      await _notificationsPlugin.cancelAll();

      // Schedule notifications for all active reminders
      for (var reminder in _reminders) {
        if (reminder.isActive) {
          await _scheduleNotificationForReminder(reminder);
        }
      }
    } catch (e) {
      print("Error scheduling all notifications: $e");
    }
  }

  // 🔹 Schedule notification for a single reminder
  Future<void> _scheduleNotificationForReminder(Reminder reminder) async {
    try {
      if (!reminder.isActive) return;

      // Extract hour and minute from reminderTime
      final hour = reminder.reminderTime.hour;
      final minute = reminder.reminderTime.minute;

      if (reminder.reminderType == 'one-time' &&
          reminder.reminderDate != null) {
        // Schedule one-time notification
        final scheduledDate = DateTime(
          reminder.reminderDate!.year,
          reminder.reminderDate!.month,
          reminder.reminderDate!.day,
          hour,
          minute,
        );

        // Only schedule if it's in the future
        if (scheduledDate.isAfter(DateTime.now())) {
          await _scheduleOneTimeNotification(
            id: reminder.id.hashCode,
            title: 'Diabetes App Reminder',
            body: reminder.title,
            scheduledDate: scheduledDate,
          );
        }
      } else if (reminder.reminderType == 'repeat') {
        if (reminder.repeatType == 'daily') {
          // Schedule daily notification
          await _scheduleDailyNotification(
            id: reminder.id.hashCode,
            title: 'Diabetes App Reminder',
            body: reminder.title,
            hour: hour,
            minute: minute,
          );
        } else
        if (reminder.repeatType == 'custom' && reminder.startsOn != null) {
          // Schedule custom notification
          final startDate = DateTime(
            reminder.startsOn!.year,
            reminder.startsOn!.month,
            reminder.startsOn!.day,
            hour,
            minute,
          );

          // Only schedule if start date is in the future or today
          if (startDate.isAfter(DateTime.now()) ||
              (startDate.year == DateTime
                  .now()
                  .year &&
                  startDate.month == DateTime
                      .now()
                      .month &&
                  startDate.day == DateTime
                      .now()
                      .day)) {
            await _scheduleDailyNotification(
              id: reminder.id.hashCode,
              title: 'Diabetes App Reminder',
              body: reminder.title,
              hour: hour,
              minute: minute,
              startDate: startDate,
              endDate: reminder.neverEnds ? null : reminder.endsOn,
            );
          }
        }
      }
    } catch (e) {
      print("Error scheduling notification for reminder ${reminder.id}: $e");
    }
  }

  // 🔹 Schedule a one-time notification
  Future<void> _scheduleOneTimeNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      final tzScheduledDate = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'diabetes_reminders',
            'Diabetes Reminders',
            channelDescription: 'Notifications for diabetes reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      print("Error scheduling one-time notification: $e");
    }
  }


  // 🔹 Schedule a daily notification
  Future<void> _scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        startDate?.year ?? now.year,
        startDate?.month ?? now.month,
        startDate?.day ?? now.day,
        hour,
        minute,
      );

      // If the scheduled time is in the past, schedule for the next day
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      // Check if the end date is specified and not passed
      if (endDate != null) {
        final tzEndDate = tz.TZDateTime(
          tz.local,
          endDate.year,
          endDate.month,
          endDate.day,
          23,
          59,
          59,
        );

        if (scheduledDate.isAfter(tzEndDate)) {
          return; // Don't schedule if beyond end date
        }
      }

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'diabetes_reminders',
            'Diabetes Reminders',
            channelDescription: 'Notifications for diabetes reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      print("Error scheduling daily notification: $e");
    }
  }
}
