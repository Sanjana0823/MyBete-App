import 'package:cloud_firestore/cloud_firestore.dart';

class LogEntry {
  final String? id;
  final String userId;
  final DateTime date;
  final double? bloodSugar;
  final String? pills;
  final String? bloodPressure;
  final double? bodyWeight;
  final String? trackingMoment;
  final String? mealTime;
  final String? foodType;
  final DateTime createdAt;
  final DateTime updatedAt;

  LogEntry({
    this.id,
    required this.userId,
    required this.date,
    this.bloodSugar,
    this.pills,
    this.bloodPressure,
    this.bodyWeight,
    this.trackingMoment,
    this.mealTime,
    this.foodType,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create LogEntry from Firestore document
  factory LogEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LogEntry(
      id: doc.id,
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      bloodSugar: data['bloodSugar']?.toDouble(),
      pills: data['pills'],
      bloodPressure: data['bloodPressure'],
      bodyWeight: data['bodyWeight']?.toDouble(),
      trackingMoment: data['trackingMoment'],
      mealTime: data['mealTime'],
      foodType: data['foodType'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert LogEntry to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'bloodSugar': bloodSugar,
      'pills': pills,
      'bloodPressure': bloodPressure,
      'bodyWeight': bodyWeight,
      'trackingMoment': trackingMoment,
      'mealTime': mealTime,
      'foodType': foodType,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create a copy of LogEntry with updated fields
  LogEntry copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? bloodSugar,
    String? pills,
    String? bloodPressure,
    double? bodyWeight,
    String? trackingMoment,
    String? mealTime,
    String? foodType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LogEntry(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        date: date ?? this.date,
        bloodSugar: bloodSugar ?? this.bloodSugar,
        pills: pills ?? this.pills,
        bloodPressure: bloodPressure ?? this.bloodPressure,
        bodyWeight: bodyWeight ?? this.bodyWeight,
        trackingMoment: trackingMoment ?? this.trackingMoment,
        mealTime: mealTime ?? this.mealTime,
        foodType: foodType ?? this.foodType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        );
    }
}