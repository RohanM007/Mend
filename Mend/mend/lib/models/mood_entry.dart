import 'package:cloud_firestore/cloud_firestore.dart';

enum MoodType {
  veryHappy,
  happy,
  neutral,
  sad,
  verySad,
  anxious,
  stressed,
  calm,
  excited,
  angry,
}

class MoodEntry {
  final String id;
  final MoodType mood;
  final int intensity; // 1-10 scale
  final String? note;
  final DateTime date;
  final DateTime createdAt;

  MoodEntry({
    required this.id,
    required this.mood,
    required this.intensity,
    this.note,
    required this.date,
    required this.createdAt,
  });

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'mood': mood.toString().split('.').last,
      'intensity': intensity,
      'note': note,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory MoodEntry.fromMap(Map<String, dynamic> map, String id) {
    return MoodEntry(
      id: id,
      mood: MoodType.values.firstWhere(
        (e) => e.toString().split('.').last == map['mood'],
        orElse: () => MoodType.neutral,
      ),
      intensity: map['intensity'] ?? 5,
      note: map['note'],
      date: (map['date'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Copy with method for updates
  MoodEntry copyWith({
    String? id,
    MoodType? mood,
    int? intensity,
    String? note,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      intensity: intensity ?? this.intensity,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Helper class for mood display information
class MoodInfo {
  final MoodType type;
  final String emoji;
  final String label;
  final String color;

  const MoodInfo({
    required this.type,
    required this.emoji,
    required this.label,
    required this.color,
  });

  static const Map<MoodType, MoodInfo> moodInfoMap = {
    MoodType.veryHappy: MoodInfo(
      type: MoodType.veryHappy,
      emoji: '😄',
      label: 'Very Happy',
      color: '#4CAF50',
    ),
    MoodType.happy: MoodInfo(
      type: MoodType.happy,
      emoji: '😊',
      label: 'Happy',
      color: '#8BC34A',
    ),
    MoodType.neutral: MoodInfo(
      type: MoodType.neutral,
      emoji: '😐',
      label: 'Neutral',
      color: '#FFC107',
    ),
    MoodType.sad: MoodInfo(
      type: MoodType.sad,
      emoji: '😢',
      label: 'Sad',
      color: '#FF9800',
    ),
    MoodType.verySad: MoodInfo(
      type: MoodType.verySad,
      emoji: '😭',
      label: 'Very Sad',
      color: '#F44336',
    ),
    MoodType.anxious: MoodInfo(
      type: MoodType.anxious,
      emoji: '😰',
      label: 'Anxious',
      color: '#9C27B0',
    ),
    MoodType.stressed: MoodInfo(
      type: MoodType.stressed,
      emoji: '😤',
      label: 'Stressed',
      color: '#E91E63',
    ),
    MoodType.calm: MoodInfo(
      type: MoodType.calm,
      emoji: '😌',
      label: 'Calm',
      color: '#00BCD4',
    ),
    MoodType.excited: MoodInfo(
      type: MoodType.excited,
      emoji: '🤩',
      label: 'Excited',
      color: '#FF5722',
    ),
    MoodType.angry: MoodInfo(
      type: MoodType.angry,
      emoji: '😠',
      label: 'Angry',
      color: '#795548',
    ),
  };

  static MoodInfo getMoodInfo(MoodType mood) {
    return moodInfoMap[mood] ?? moodInfoMap[MoodType.neutral]!;
  }
}
