import 'package:cloud_firestore/cloud_firestore.dart';

enum WellnessCategory {
  motivation,
  selfLove,
  mindfulness,
  resilience,
  gratitude,
  stress,
  anxiety,
  sleep,
  productivity,
  relationships,
}

class Affirmation {
  final String id;
  final String text;
  final WellnessCategory category;
  final String? author;
  final bool isFavorite;
  final DateTime createdAt;

  Affirmation({
    required this.id,
    required this.text,
    required this.category,
    this.author,
    this.isFavorite = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'category': category.toString().split('.').last,
      'author': author,
      'isFavorite': isFavorite,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Affirmation.fromMap(Map<String, dynamic> map, String id) {
    return Affirmation(
      id: id,
      text: map['text'] ?? '',
      category: WellnessCategory.values.firstWhere(
        (e) => e.toString().split('.').last == map['category'],
        orElse: () => WellnessCategory.motivation,
      ),
      author: map['author'],
      isFavorite: map['isFavorite'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Affirmation copyWith({
    String? id,
    String? text,
    WellnessCategory? category,
    String? author,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return Affirmation(
      id: id ?? this.id,
      text: text ?? this.text,
      category: category ?? this.category,
      author: author ?? this.author,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get categoryDisplayName {
    switch (category) {
      case WellnessCategory.motivation:
        return 'Motivation';
      case WellnessCategory.selfLove:
        return 'Self-Love';
      case WellnessCategory.mindfulness:
        return 'Mindfulness';
      case WellnessCategory.resilience:
        return 'Resilience';
      case WellnessCategory.gratitude:
        return 'Gratitude';
      case WellnessCategory.stress:
        return 'Stress Relief';
      case WellnessCategory.anxiety:
        return 'Anxiety';
      case WellnessCategory.sleep:
        return 'Sleep';
      case WellnessCategory.productivity:
        return 'Productivity';
      case WellnessCategory.relationships:
        return 'Relationships';
    }
  }
}

class WellnessTip {
  final String id;
  final String title;
  final String content;
  final WellnessCategory category;
  final String? imageUrl;
  final List<String> tags;
  final int readingTimeMinutes;
  final bool isBookmarked;
  final DateTime createdAt;

  WellnessTip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    this.tags = const [],
    required this.readingTimeMinutes,
    this.isBookmarked = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'category': category.toString().split('.').last,
      'imageUrl': imageUrl,
      'tags': tags,
      'readingTimeMinutes': readingTimeMinutes,
      'isBookmarked': isBookmarked,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory WellnessTip.fromMap(Map<String, dynamic> map, String id) {
    return WellnessTip(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: WellnessCategory.values.firstWhere(
        (e) => e.toString().split('.').last == map['category'],
        orElse: () => WellnessCategory.motivation,
      ),
      imageUrl: map['imageUrl'],
      tags: List<String>.from(map['tags'] ?? []),
      readingTimeMinutes: map['readingTimeMinutes'] ?? 1,
      isBookmarked: map['isBookmarked'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  WellnessTip copyWith({
    String? id,
    String? title,
    String? content,
    WellnessCategory? category,
    String? imageUrl,
    List<String>? tags,
    int? readingTimeMinutes,
    bool? isBookmarked,
    DateTime? createdAt,
  }) {
    return WellnessTip(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      readingTimeMinutes: readingTimeMinutes ?? this.readingTimeMinutes,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get categoryDisplayName {
    switch (category) {
      case WellnessCategory.motivation:
        return 'Motivation';
      case WellnessCategory.selfLove:
        return 'Self-Love';
      case WellnessCategory.mindfulness:
        return 'Mindfulness';
      case WellnessCategory.resilience:
        return 'Resilience';
      case WellnessCategory.gratitude:
        return 'Gratitude';
      case WellnessCategory.stress:
        return 'Stress Relief';
      case WellnessCategory.anxiety:
        return 'Anxiety';
      case WellnessCategory.sleep:
        return 'Sleep';
      case WellnessCategory.productivity:
        return 'Productivity';
      case WellnessCategory.relationships:
        return 'Relationships';
    }
  }
}

// Daily wellness quote
class DailyQuote {
  final String text;
  final String author;
  final WellnessCategory category;

  const DailyQuote({
    required this.text,
    required this.author,
    required this.category,
  });
}
