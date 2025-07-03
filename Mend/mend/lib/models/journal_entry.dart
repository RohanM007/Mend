import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final String? prompt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    this.prompt,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
  });

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'prompt': prompt,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'tags': tags,
    };
  }

  // Create from Firestore document
  factory JournalEntry.fromMap(Map<String, dynamic> map, String id) {
    return JournalEntry(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      prompt: map['prompt'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  // Copy with method for updates
  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    String? prompt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      prompt: prompt ?? this.prompt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }

  // Get word count
  int get wordCount {
    if (content.isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }

  // Get reading time estimate (average 200 words per minute)
  int get readingTimeMinutes {
    return (wordCount / 200).ceil();
  }
}

// Journal prompts for inspiration
class JournalPrompts {
  static const List<String> dailyPrompts = [
    "What made you smile today?",
    "What's weighing on your heart?",
    "If God could hear one thing from you right now, what would it be?",
    "What are you grateful for today?",
    "What challenged you today and how did you handle it?",
    "Describe a moment when you felt truly peaceful today.",
    "What would you tell your younger self about today?",
    "What's one thing you learned about yourself today?",
    "How did you show kindness to yourself or others today?",
    "What emotions did you experience today and why?",
    "What's something you're looking forward to?",
    "How did you take care of your mental health today?",
    "What's a small victory you achieved today?",
    "What would you like to let go of from today?",
    "How did you connect with others today?",
    "What's something beautiful you noticed today?",
    "What's a fear you faced today?",
    "How did you practice self-compassion today?",
    "What's something you wish you could change about today?",
    "What's a hope you're holding onto?",
  ];

  static const List<String> reflectionPrompts = [
    "What patterns do you notice in your thoughts lately?",
    "How have you grown in the past month?",
    "What relationships in your life bring you joy?",
    "What's a belief about yourself you'd like to change?",
    "How do you want to be remembered?",
    "What's your relationship with rest and relaxation?",
    "What boundaries do you need to set in your life?",
    "What's something you've been avoiding and why?",
    "How do you handle difficult emotions?",
    "What does self-love look like for you?",
  ];

  static const List<String> spiritualPrompts = [
    "How do you experience the divine in your daily life?",
    "What brings you a sense of peace and connection?",
    "What are you seeking guidance on right now?",
    "How do you practice gratitude in difficult times?",
    "What does forgiveness mean to you?",
    "How do you find hope when things feel dark?",
    "What spiritual practices bring you comfort?",
    "How do you see love manifesting in your life?",
    "What's a prayer or intention you're holding?",
    "How do you find meaning in your struggles?",
  ];

  static String getRandomPrompt() {
    final allPrompts = [...dailyPrompts, ...reflectionPrompts, ...spiritualPrompts];
    allPrompts.shuffle();
    return allPrompts.first;
  }

  static String getDailyPrompt() {
    final now = DateTime.now();
    final index = now.day % dailyPrompts.length;
    return dailyPrompts[index];
  }
}
