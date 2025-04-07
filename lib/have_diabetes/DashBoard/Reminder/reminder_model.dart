// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Reminder {
//   String id;
//   String title;
//   String reminderType; // 'one-time' or 'repeat'
//   String repeatType; // 'daily' or 'custom' (only for repeat)
//   DateTime? reminderDate; // Only for 'one-time'
//   DateTime reminderTime;
//   DateTime? startsOn; // Only for 'custom' repeat
//   DateTime? endsOn; // Only for 'custom' repeat
//   bool neverEnds;
//   String note;
//   bool isActive;
//   String userId; // Added to associate reminders with specific users
//
//   Reminder({
//     required this.id,
//     required this.title,
//     required this.reminderType,
//     required this.repeatType,
//     this.reminderDate,
//     required this.reminderTime,
//     this.startsOn,
//     this.endsOn,
//     required this.neverEnds,
//     required this.note,
//     required this.isActive,
//     required this.userId,
//   });
//
//   // Convert Reminder object to Firestore JSON format
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'reminderType': reminderType,
//       'repeatType': repeatType,
//       'reminderDate': reminderDate?.toIso8601String(),
//       'reminderTime': reminderTime.toIso8601String(),
//       'startsOn': startsOn?.toIso8601String(),
//       'endsOn': endsOn?.toIso8601String(),
//       'neverEnds': neverEnds,
//       'note': note,
//       'isActive': isActive,
//       'userId': userId,
//       'createdAt': FieldValue.serverTimestamp(), // Add server timestamp
//     };
//   }
//
//   // Create Reminder object from Firestore snapshot
//   factory Reminder.fromJson(Map<String, dynamic> json) {
//     return Reminder(
//       id: json['id'],
//       title: json['title'],
//       reminderType: json['reminderType'],
//       repeatType: json['repeatType'],
//       reminderDate: json['reminderDate'] != null ? DateTime.parse(json['reminderDate']) : null,
//       reminderTime: DateTime.parse(json['reminderTime']),
//       startsOn: json['startsOn'] != null ? DateTime.parse(json['startsOn']) : null,
//       endsOn: json['endsOn'] != null ? DateTime.parse(json['endsOn']) : null,
//       neverEnds: json['neverEnds'] ?? true,
//       note: json['note'] ?? '',
//       isActive: json['isActive'] ?? true,
//       userId: json['userId'] ?? '',
//     );
//   }
//
//   // Create a copy of the reminder with updated fields
//   Reminder copyWith({
//     String? title,
//     String? reminderType,
//     String? repeatType,
//     DateTime? reminderDate,
//     DateTime? reminderTime,
//     DateTime? startsOn,
//     DateTime? endsOn,
//     bool? neverEnds,
//     String? note,
//     bool? isActive,
//   }) {
//     return Reminder(
//       id: this.id,
//       title: title ?? this.title,
//       reminderType: reminderType ?? this.reminderType,
//       repeatType: repeatType ?? this.repeatType,
//       reminderDate: reminderDate ?? this.reminderDate,
//       reminderTime: reminderTime ?? this.reminderTime,
//       startsOn: startsOn ?? this.startsOn,
//       endsOn: endsOn ?? this.endsOn,
//       neverEnds: neverEnds ?? this.neverEnds,
//       note: note ?? this.note,
//       isActive: isActive ?? this.isActive,
//       userId: this.userId,
//     );
//   }
// }
//
//
//
//
//

// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Reminder {
//   String id;
//   String title;
//   String reminderType; // 'one-time' or 'repeat'
//   String repeatType; // 'daily' or 'custom' (only for repeat)
//   DateTime? reminderDate; // Only for 'one-time'
//   DateTime reminderTime;
//   DateTime? startsOn; // Only for 'custom' repeat
//   DateTime? endsOn; // Only for 'custom' repeat
//   bool neverEnds;
//   String note;
//   bool isActive;
//   String userId; // Added to associate reminders with specific users
//
//   Reminder({
//     required this.id,
//     required this.title,
//     required this.reminderType,
//     required this.repeatType,
//     this.reminderDate,
//     required this.reminderTime,
//     this.startsOn,
//     this.endsOn,
//     required this.neverEnds,
//     required this.note,
//     required this.isActive,
//     required this.userId,
//   });
//
//   // Convert Reminder object to Firestore JSON format
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'reminderType': reminderType,
//       'repeatType': repeatType,
//       'reminderDate': reminderDate?.toIso8601String(),
//       'reminderTime': reminderTime.toIso8601String(),
//       'startsOn': startsOn?.toIso8601String(),
//       'endsOn': endsOn?.toIso8601String(),
//       'neverEnds': neverEnds,
//       'note': note,
//       'isActive': isActive,
//       'userId': userId,
//       'createdAt': FieldValue.serverTimestamp(), // Add server timestamp
//     };
//   }
//
//   // Create Reminder object from Firestore snapshot
//   factory Reminder.fromJson(Map<String, dynamic> json) {
//     return Reminder(
//       id: json['id'],
//       title: json['title'],
//       reminderType: json['reminderType'],
//       repeatType: json['repeatType'],
//       reminderDate: json['reminderDate'] != null ? DateTime.parse(json['reminderDate']) : null,
//       reminderTime: DateTime.parse(json['reminderTime']),
//       startsOn: json['startsOn'] != null ? DateTime.parse(json['startsOn']) : null,
//       endsOn: json['endsOn'] != null ? DateTime.parse(json['endsOn']) : null,
//       neverEnds: json['neverEnds'] ?? true,
//       note: json['note'] ?? '',
//       isActive: json['isActive'] ?? true,
//       userId: json['userId'] ?? '',
//     );
//   }
//
//   // Create a copy of the reminder with updated fields
//   Reminder copyWith({
//     String? title,
//     String? reminderType,
//     String? repeatType,
//     DateTime? reminderDate,
//     DateTime? reminderTime,
//     DateTime? startsOn,
//     DateTime? endsOn,
//     bool? neverEnds,
//     String? note,
//     bool? isActive,
//   }) {
//     return Reminder(
//       id: this.id,
//       title: title ?? this.title,
//       reminderType: reminderType ?? this.reminderType,
//       repeatType: repeatType ?? this.repeatType,
//       reminderDate: reminderDate ?? this.reminderDate,
//       reminderTime: reminderTime ?? this.reminderTime,
//       startsOn: startsOn ?? this.startsOn,
//       endsOn: endsOn ?? this.endsOn,
//       neverEnds: neverEnds ?? this.neverEnds,
//       note: note ?? this.note,
//       isActive: isActive ?? this.isActive,
//       userId: this.userId,
//     );
//   }
// }






import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  String id;
  String title;
  String reminderType; // 'one-time' or 'repeat'
  String repeatType; // 'daily' or 'custom' (only for repeat)
  DateTime? reminderDate; // Only for 'one-time'
  DateTime reminderTime;
  DateTime? startsOn; // Only for 'custom' repeat
  DateTime? endsOn; // Only for 'custom' repeat
  bool neverEnds;
  String note;
  bool isActive;
  String userId; // Added to associate reminders with specific users

  Reminder({
    required this.id,
    required this.title,
    required this.reminderType,
    required this.repeatType,
    this.reminderDate,
    required this.reminderTime,
    this.startsOn,
    this.endsOn,
    required this.neverEnds,
    required this.note,
    required this.isActive,
    required this.userId,
  });

  // Convert Reminder object to Firestore JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'reminderType': reminderType,
      'repeatType': repeatType,
      'reminderDate': reminderDate?.toIso8601String(),
      'reminderTime': reminderTime.toIso8601String(),
      'startsOn': startsOn?.toIso8601String(),
      'endsOn': endsOn?.toIso8601String(),
      'neverEnds': neverEnds,
      'note': note,
      'isActive': isActive,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(), // Add server timestamp
    };
  }

  // Create Reminder object from Firestore snapshot
  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      reminderType: json['reminderType'] ?? 'one-time',
      repeatType: json['repeatType'] ?? 'daily',
      reminderDate: json['reminderDate'] != null ? DateTime.parse(json['reminderDate']) : null,
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'])
          : DateTime.now(),
      startsOn: json['startsOn'] != null ? DateTime.parse(json['startsOn']) : null,
      endsOn: json['endsOn'] != null ? DateTime.parse(json['endsOn']) : null,
      neverEnds: json['neverEnds'] ?? true,
      note: json['note'] ?? '',
      isActive: json['isActive'] ?? true,
      userId: json['userId'] ?? '',
    );
  }

  // Create a copy of the reminder with updated fields
  Reminder copyWith({
    String? title,
    String? reminderType,
    String? repeatType,
    DateTime? reminderDate,
    DateTime? reminderTime,
    DateTime? startsOn,
    DateTime? endsOn,
    bool? neverEnds,
    String? note,
    bool? isActive,
  }) {
    return Reminder(
      id: this.id,
      title: title ?? this.title,
      reminderType: reminderType ?? this.reminderType,
      repeatType: repeatType ?? this.repeatType,
      reminderDate: reminderDate ?? this.reminderDate,
      reminderTime: reminderTime ?? this.reminderTime,
      startsOn: startsOn ?? this.startsOn,
      endsOn: endsOn ?? this.endsOn,
      neverEnds: neverEnds ?? this.neverEnds,
      note: note ?? this.note,
      isActive: isActive ?? this.isActive,
      userId: this.userId,
    );
  }
}