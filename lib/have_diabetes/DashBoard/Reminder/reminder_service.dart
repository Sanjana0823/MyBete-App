// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_model.dart';
//
// class ReminderService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Get reference to the reminders collection
//   CollectionReference get remindersCollection =>
//       _firestore.collection('reminders');
//
//   // Get current user ID
//   String get currentUserId => _auth.currentUser?.uid ?? '';
//
//   // 🔹 Add Reminder
//   Future<void> addReminder(Reminder reminder) async {
//     try {
//       // Ensure the reminder has the current user ID
//       final reminderWithUserId = Reminder(
//         id: reminder.id,
//         title: reminder.title,
//         reminderType: reminder.reminderType,
//         repeatType: reminder.repeatType,
//         reminderDate: reminder.reminderDate,
//         reminderTime: reminder.reminderTime,
//         startsOn: reminder.startsOn,
//         endsOn: reminder.endsOn,
//         neverEnds: reminder.neverEnds,
//         note: reminder.note,
//         isActive: reminder.isActive,
//         userId: currentUserId,
//       );
//
//       await remindersCollection.doc(reminder.id).set(reminderWithUserId.toJson());
//     } catch (e) {
//       print("Error adding reminder: $e");
//       rethrow; // Rethrow to handle in the UI
//     }
//   }
//
//   // 🔹 Fetch All Reminders for current user
//   Stream<List<Reminder>> getReminders() {
//     return remindersCollection
//         .where('userId', isEqualTo: currentUserId)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs
//           .map((doc) => Reminder.fromJson(doc.data() as Map<String, dynamic>))
//           .toList();
//     });
//   }
//
//   // 🔹 Update Reminder
//   Future<void> updateReminder(Reminder reminder) async {
//     try {
//       // First check if the document exists and belongs to the current user
//       final docSnapshot = await remindersCollection.doc(reminder.id).get();
//
//       if (!docSnapshot.exists) {
//         throw Exception("Reminder not found");
//       }
//
//       final data = docSnapshot.data() as Map<String, dynamic>;
//       if (data['userId'] != currentUserId) {
//         throw Exception("You don't have permission to update this reminder");
//       }
//
//       // Update the reminder
//       await remindersCollection.doc(reminder.id).update({
//         'title': reminder.title,
//         'reminderType': reminder.reminderType,
//         'repeatType': reminder.repeatType,
//         'reminderDate': reminder.reminderDate?.toIso8601String(),
//         'reminderTime': reminder.reminderTime.toIso8601String(),
//         'startsOn': reminder.startsOn?.toIso8601String(),
//         'endsOn': reminder.endsOn?.toIso8601String(),
//         'neverEnds': reminder.neverEnds,
//         'note': reminder.note,
//         'isActive': reminder.isActive,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error updating reminder: $e");
//       rethrow;
//     }
//   }
//
//   // 🔹 Delete Reminder
//   Future<void> deleteReminder(String id) async {
//     try {
//       // First check if the document exists and belongs to the current user
//       final docSnapshot = await remindersCollection.doc(id).get();
//
//       if (!docSnapshot.exists) {
//         throw Exception("Reminder not found");
//       }
//
//       final data = docSnapshot.data() as Map<String, dynamic>;
//       if (data['userId'] != currentUserId) {
//         throw Exception("You don't have permission to delete this reminder");
//       }
//
//       // Delete the reminder
//       await remindersCollection.doc(id).delete();
//     } catch (e) {
//       print("Error deleting reminder: $e");
//       rethrow;
//     }
//   }
//
//   // 🔹 Toggle Reminder Active Status
//   Future<void> toggleReminderActive(String id, bool isActive) async {
//     try {
//       await remindersCollection.doc(id).update({
//         'isActive': isActive,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error toggling reminder status: $e");
//       rethrow;
//     }
//   }
//
//   // 🔹 Get a single reminder by ID
//   Future<Reminder?> getReminderById(String id) async {
//     try {
//       final docSnapshot = await remindersCollection.doc(id).get();
//
//       if (!docSnapshot.exists) {
//         return null;
//       }
//
//       final data = docSnapshot.data() as Map<String, dynamic>;
//       if (data['userId'] != currentUserId) {
//         return null; // Don't return reminders that don't belong to the user
//       }
//
//       return Reminder.fromJson(data);
//     } catch (e) {
//       print("Error getting reminder: $e");
//       return null;
//     }
//   }
// }
//
//
//
//
//
//





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_model.dart';
//
// class ReminderService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Get reference to the reminders collection
//   CollectionReference get remindersCollection =>
//       _firestore.collection('reminders');
//
//   // Get current user ID
//   String get currentUserId => _auth.currentUser?.uid ?? '';
//
//   // 🔹 Add Reminder
//   Future<void> addReminder(Reminder reminder) async {
//     try {
//       // Ensure the reminder has the current user ID
//       final reminderWithUserId = Reminder(
//         id: reminder.id,
//         title: reminder.title,
//         reminderType: reminder.reminderType,
//         repeatType: reminder.repeatType,
//         reminderDate: reminder.reminderDate,
//         reminderTime: reminder.reminderTime,
//         startsOn: reminder.startsOn,
//         endsOn: reminder.endsOn,
//         neverEnds: reminder.neverEnds,
//         note: reminder.note,
//         isActive: reminder.isActive,
//         userId: currentUserId,
//       );
//
//       await remindersCollection.doc(reminder.id).set(reminderWithUserId.toJson());
//     } catch (e) {
//       print("Error adding reminder: $e");
//       rethrow; // Rethrow to handle in the UI
//     }
//   }
//
//   // 🔹 Fetch All Reminders for current user
//   Stream<List<Reminder>> getReminders() {
//     return remindersCollection
//         .where('userId', isEqualTo: currentUserId)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs
//           .map((doc) => Reminder.fromJson(doc.data() as Map<String, dynamic>))
//           .toList();
//     });
//   }
//
//   // 🔹 Update Reminder
//   Future<void> updateReminder(Reminder reminder) async {
//     try {
//       // First check if the document exists and belongs to the current user
//       final docSnapshot = await remindersCollection.doc(reminder.id).get();
//
//       if (!docSnapshot.exists) {
//         throw Exception("Reminder not found");
//       }
//
//       final data = docSnapshot.data() as Map<String, dynamic>;
//       if (data['userId'] != currentUserId) {
//         throw Exception("You don't have permission to update this reminder");
//       }
//
//       // Update the reminder
//       await remindersCollection.doc(reminder.id).update({
//         'title': reminder.title,
//         'reminderType': reminder.reminderType,
//         'repeatType': reminder.repeatType,
//         'reminderDate': reminder.reminderDate?.toIso8601String(),
//         'reminderTime': reminder.reminderTime.toIso8601String(),
//         'startsOn': reminder.startsOn?.toIso8601String(),
//         'endsOn': reminder.endsOn?.toIso8601String(),
//         'neverEnds': reminder.neverEnds,
//         'note': reminder.note,
//         'isActive': reminder.isActive,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error updating reminder: $e");
//       rethrow;
//     }
//   }
//
//   // 🔹 Delete Reminder
//   Future<void> deleteReminder(String id) async {
//     try {
//       // First check if the document exists and belongs to the current user
//       final docSnapshot = await remindersCollection.doc(id).get();
//
//       if (!docSnapshot.exists) {
//         throw Exception("Reminder not found");
//       }
//
//       final data = docSnapshot.data() as Map<String, dynamic>;
//       if (data['userId'] != currentUserId) {
//         throw Exception("You don't have permission to delete this reminder");
//       }
//
//       // Delete the reminder
//       await remindersCollection.doc(id).delete();
//     } catch (e) {
//       print("Error deleting reminder: $e");
//       rethrow;
//     }
//   }
//
//   // 🔹 Toggle Reminder Active Status
//   Future<void> toggleReminderActive(String id, bool isActive) async {
//     try {
//       await remindersCollection.doc(id).update({
//         'isActive': isActive,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error toggling reminder status: $e");
//       rethrow;
//     }
//   }
//
//   // 🔹 Get a single reminder by ID
//   Future<Reminder?> getReminderById(String id) async {
//     try {
//       final docSnapshot = await remindersCollection.doc(id).get();
//
//       if (!docSnapshot.exists) {
//         return null;
//       }
//
//       final data = docSnapshot.data() as Map<String, dynamic>;
//       if (data['userId'] != currentUserId) {
//         return null; // Don't return reminders that don't belong to the user
//       }
//
//       return Reminder.fromJson(data);
//     } catch (e) {
//       print("Error getting reminder: $e");
//       return null;
//     }
//   }
// }





import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybete_app/have_diabetes/DashBoard/Reminder/reminder_model.dart';

class ReminderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get reference to the reminders collection
  CollectionReference get remindersCollection =>
      _firestore.collection('reminders');

  // Get current user ID
  String get currentUserId => _auth.currentUser?.uid ?? '';

  // 🔹 Add Reminder
  Future<void> addReminder(Reminder reminder) async {
    try {
      // Ensure the reminder has the current user ID
      final reminderWithUserId = Reminder(
        id: reminder.id,
        title: reminder.title,
        reminderType: reminder.reminderType,
        repeatType: reminder.repeatType,
        reminderDate: reminder.reminderDate,
        reminderTime: reminder.reminderTime,
        startsOn: reminder.startsOn,
        endsOn: reminder.endsOn,
        neverEnds: reminder.neverEnds,
        note: reminder.note,
        isActive: reminder.isActive,
        userId: currentUserId,
      );

      await remindersCollection.doc(reminder.id).set(reminderWithUserId.toJson());
    } catch (e) {
      print("Error adding reminder: $e");
      rethrow; // Rethrow to handle in the UI
    }
  }

  // 🔹 Fetch All Reminders for current user
  Stream<List<Reminder>> getReminders() {
    try {
      // Check if user is logged in
      if (currentUserId.isEmpty) {
        return Stream.value([]);
      }

      // Modified query to avoid index issues
      return remindersCollection
          .where('userId', isEqualTo: currentUserId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Reminder.fromJson(doc.data() as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => b.id.compareTo(a.id)); // Sort by ID as a fallback
      });
    } catch (e) {
      print("Error getting reminders: $e");
      return Stream.error(e);
    }
  }

  // 🔹 Update Reminder
  Future<void> updateReminder(Reminder reminder) async {
    try {
      // First check if the document exists and belongs to the current user
      final docSnapshot = await remindersCollection.doc(reminder.id).get();

      if (!docSnapshot.exists) {
        throw Exception("Reminder not found");
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      if (data['userId'] != currentUserId) {
        throw Exception("You don't have permission to update this reminder");
      }

      // Update the reminder
      await remindersCollection.doc(reminder.id).update({
        'title': reminder.title,
        'reminderType': reminder.reminderType,
        'repeatType': reminder.repeatType,
        'reminderDate': reminder.reminderDate?.toIso8601String(),
        'reminderTime': reminder.reminderTime.toIso8601String(),
        'startsOn': reminder.startsOn?.toIso8601String(),
        'endsOn': reminder.endsOn?.toIso8601String(),
        'neverEnds': reminder.neverEnds,
        'note': reminder.note,
        'isActive': reminder.isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error updating reminder: $e");
      rethrow;
    }
  }

  // 🔹 Delete Reminder
  Future<void> deleteReminder(String id) async {
    try {
      // First check if the document exists and belongs to the current user
      final docSnapshot = await remindersCollection.doc(id).get();

      if (!docSnapshot.exists) {
        throw Exception("Reminder not found");
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      if (data['userId'] != currentUserId) {
        throw Exception("You don't have permission to delete this reminder");
      }

      // Delete the reminder
      await remindersCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting reminder: $e");
      rethrow;
    }
  }

  // 🔹 Toggle Reminder Active Status
  Future<void> toggleReminderActive(String id, bool isActive) async {
    try {
      await remindersCollection.doc(id).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error toggling reminder status: $e");
      rethrow;
    }
  }

  // 🔹 Get a single reminder by ID
  Future<Reminder?> getReminderById(String id) async {
    try {
      final docSnapshot = await remindersCollection.doc(id).get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      if (data['userId'] != currentUserId) {
        return null; // Don't return reminders that don't belong to the user
      }

      return Reminder.fromJson(data);
    } catch (e) {
      print("Error getting reminder: $e");
      return null;
    }
  }
}