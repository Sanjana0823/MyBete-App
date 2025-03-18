import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_model.dart';

class ReminderService {
  final CollectionReference remindersCollection =
  FirebaseFirestore.instance.collection('reminders');

  // 🔹 Add Reminder
  Future<void> addReminder(Reminder reminder) async {
    try {
      await remindersCollection.doc(reminder.id).set(reminder.toJson());
    } catch (e) {
      print("Error adding reminder: $e");
    }
  }

  // 🔹 Fetch All Reminders
  Stream<List<Reminder>> getReminders() {
    return remindersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Reminder.fromJson(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  // 🔹 Update Reminder
  Future<void> updateReminder(Reminder reminder) async {
    try {
      await remindersCollection.doc(reminder.id).update(reminder.toJson());
    } catch (e) {
      print("Error updating reminder: $e");
    }
  }

  // 🔹 Delete Reminder
  Future<void> deleteReminder(String id) async {
    try {
      await remindersCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting reminder: $e");
    }
  }
 }
