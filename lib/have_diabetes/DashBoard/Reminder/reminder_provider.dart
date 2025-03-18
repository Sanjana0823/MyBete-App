import 'package:flutter/material.dart';
import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_model.dart';
import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_service.dart';

class ReminderProvider with ChangeNotifier {
  final ReminderService _reminderService = ReminderService();
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  // 🔹 Load Reminders from Firestore
  void loadReminders() {
    _reminderService.getReminders().listen((reminders) {
      _reminders = reminders;
      notifyListeners();
    });
  }

  // 🔹 Add Reminder
  Future<void> addReminder(Reminder reminder) async {
    await _reminderService.addReminder(reminder);
    loadReminders();
  }

  // 🔹 Update Reminder
  Future<void> updateReminder(Reminder reminder) async {
    await _reminderService.updateReminder(reminder);
    loadReminders();
  }

  // 🔹 Delete Reminder
  Future<void> deleteReminder(String id) async {
    await _reminderService.deleteReminder(id);
    loadReminders();
  }
}



