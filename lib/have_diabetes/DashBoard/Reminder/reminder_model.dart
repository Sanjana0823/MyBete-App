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
    };
  }

  // Create Reminder object from Firestore snapshot
  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      reminderType: json['reminderType'],
      repeatType: json['repeatType'],
      reminderDate: json['reminderDate'] != null ? DateTime.parse(json['reminderDate']) : null,
      reminderTime: DateTime.parse(json['reminderTime']),
      startsOn: json['startsOn'] != null ? DateTime.parse(json['startsOn']) : null,
      endsOn: json['endsOn'] != null ? DateTime.parse(json['endsOn']) : null,
      neverEnds: json['neverEnds'],
      note: json['note'],
    );
  }
}






