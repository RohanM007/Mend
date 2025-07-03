import 'package:cloud_firestore/cloud_firestore.dart';

enum MeditationType { guided, music, nature, breathing }

class Meditation {
  final String id;
  final String title;
  final String description;
  final String category;
  final int durationMinutes;
  final MeditationType type;
  final String? audioUrl;
  final String? imageUrl;
  final String? instructor;
  final List<String> tags;
  final int difficulty; // 1-5 scale
  final bool isPremium;
  final DateTime createdAt;

  Meditation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationMinutes,
    required this.type,
    this.audioUrl,
    this.imageUrl,
    this.instructor,
    this.tags = const [],
    this.difficulty = 1,
    this.isPremium = false,
    required this.createdAt,
  });

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'durationMinutes': durationMinutes,
      'type': type.toString().split('.').last,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'instructor': instructor,
      'tags': tags,
      'difficulty': difficulty,
      'isPremium': isPremium,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory Meditation.fromMap(Map<String, dynamic> map, String id) {
    return Meditation(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 0,
      type: MeditationType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => MeditationType.guided,
      ),
      audioUrl: map['audioUrl'],
      imageUrl: map['imageUrl'],
      instructor: map['instructor'],
      tags: List<String>.from(map['tags'] ?? []),
      difficulty: map['difficulty'] ?? 1,
      isPremium: map['isPremium'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Copy with method for updates
  Meditation copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? durationMinutes,
    MeditationType? type,
    String? audioUrl,
    String? imageUrl,
    String? instructor,
    List<String>? tags,
    int? difficulty,
    bool? isPremium,
    DateTime? createdAt,
  }) {
    return Meditation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      type: type ?? this.type,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      instructor: instructor ?? this.instructor,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Get formatted duration
  String get formattedDuration {
    if (durationMinutes < 60) {
      return '${durationMinutes}m';
    } else {
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      if (minutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${minutes}m';
      }
    }
  }

  // Get difficulty text
  String get difficultyText {
    switch (difficulty) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Easy';
      case 3:
        return 'Intermediate';
      case 4:
        return 'Advanced';
      case 5:
        return 'Expert';
      default:
        return 'Beginner';
    }
  }

  // Get type display name
  String get typeDisplayName {
    switch (type) {
      case MeditationType.guided:
        return 'Guided';
      case MeditationType.music:
        return 'Music';
      case MeditationType.nature:
        return 'Nature Sounds';
      case MeditationType.breathing:
        return 'Breathing';
    }
  }
}

// Meditation session for tracking user progress
class MeditationSession {
  final String id;
  final String meditationId;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationMinutes;
  final bool completed;
  final double? rating;
  final String? notes;

  MeditationSession({
    required this.id,
    required this.meditationId,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.durationMinutes,
    this.completed = false,
    this.rating,
    this.notes,
  });

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'meditationId': meditationId,
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'durationMinutes': durationMinutes,
      'completed': completed,
      'rating': rating,
      'notes': notes,
    };
  }

  // Create from Firestore document
  factory MeditationSession.fromMap(Map<String, dynamic> map, String id) {
    return MeditationSession(
      id: id,
      meditationId: map['meditationId'] ?? '',
      userId: map['userId'] ?? '',
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime:
          map['endTime'] != null
              ? (map['endTime'] as Timestamp).toDate()
              : null,
      durationMinutes: map['durationMinutes'] ?? 0,
      completed: map['completed'] ?? false,
      rating: map['rating']?.toDouble(),
      notes: map['notes'],
    );
  }

  // Copy with method for updates
  MeditationSession copyWith({
    String? id,
    String? meditationId,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    bool? completed,
    double? rating,
    String? notes,
  }) {
    return MeditationSession(
      id: id ?? this.id,
      meditationId: meditationId ?? this.meditationId,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      completed: completed ?? this.completed,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
    );
  }
}

// Default meditations data - Now with working YouTube/Spotify links
class DefaultMeditations {
  static List<Meditation> get defaultMeditations => [
    // ANXIETY RELIEF VIDEOS
    Meditation(
      id: 'yt_anxiety_education',
      title: 'How to Spot Normal Anxiety VS Anxiety Disorders',
      description:
          'Professional explanation of the difference between normal anxiety and anxiety disorders. Educational content from mental health experts.',
      category: 'Anxiety',
      durationMinutes: 23,
      type: MeditationType.guided,
      audioUrl: 'https://www.youtube.com/watch?v=T4E2JzmIraw',
      instructor: 'MedCircle',
      tags: ['anxiety', 'education', 'professional', 'mental health'],
      difficulty: 1,
      createdAt: DateTime.now(),
    ),
    Meditation(
      id: 'yt_anxiety_meditation',
      title: 'GUIDED MEDITATION - Anxiety Relief',
      description:
          'A calming guided meditation specifically designed to help relieve anxiety and promote relaxation.',
      category: 'Anxiety',
      durationMinutes: 13,
      type: MeditationType.guided,
      audioUrl: 'https://www.youtube.com/watch?v=8_jcEpwKQXc',
      instructor: 'The Honest Guys',
      tags: ['anxiety', 'guided meditation', 'relaxation', 'calming'],
      difficulty: 1,
      createdAt: DateTime.now(),
    ),

    // STRESS RELIEF
    Meditation(
      id: 'yt_stress_relief',
      title: 'De-stress in 5 Minutes: Mind and Body Meditation',
      description:
          'Quick and effective stress relief meditation for busy schedules. Guided by Elisha Mudly from Headspace.',
      category: 'Stress Relief',
      durationMinutes: 5,
      type: MeditationType.guided,
      audioUrl: 'https://www.youtube.com/watch?v=wE292vsJcBY',
      instructor: 'Headspace',
      tags: ['stress', 'quick', 'meditation', 'mindfulness'],
      difficulty: 1,
      createdAt: DateTime.now(),
    ),

    // DEPRESSION SUPPORT
    Meditation(
      id: 'yt_depression_meditation',
      title: 'Guided Meditation for Detachment From Over-Thinking',
      description:
          'A comprehensive guided meditation to help detach from overthinking patterns associated with anxiety, OCD, and depression.',
      category: 'Depression',
      durationMinutes: 43,
      type: MeditationType.guided,
      audioUrl: 'https://www.youtube.com/watch?v=1vx8iUvfyCY',
      instructor: 'Michael Sealey',
      tags: [
        'depression',
        'overthinking',
        'anxiety',
        'OCD',
        'guided meditation',
      ],
      difficulty: 2,
      createdAt: DateTime.now(),
    ),
    Meditation(
      id: 'yt_depression_education',
      title: 'What is depression? - Helen M. Farrell',
      description:
          'TED-Ed educational video explaining what depression is, its symptoms, and how it affects the brain.',
      category: 'Depression',
      durationMinutes: 5,
      type: MeditationType.guided,
      audioUrl: 'https://www.youtube.com/watch?v=z-IR48Mb3W0',
      instructor: 'TED-Ed',
      tags: ['depression', 'education', 'TED-Ed', 'mental health'],
      difficulty: 1,
      createdAt: DateTime.now(),
    ),

    // SLEEP MEDITATION
    Meditation(
      id: 'yt_sleep_meditation',
      title: 'Guided Sleep Meditation: The Haven of Peace',
      description:
          'A soothing guided sleep meditation designed to help you fall asleep quickly with ultra deep relaxation. Features a dark screen for better sleep.',
      category: 'Sleep',
      durationMinutes: 13,
      type: MeditationType.guided,
      audioUrl: 'https://www.youtube.com/watch?v=TP2gb2fSYXY',
      instructor: 'The Honest Guys',
      tags: ['sleep', 'deep relaxation', 'dark screen', 'guided meditation'],
      difficulty: 1,
      createdAt: DateTime.now(),
    ),

    // SPOTIFY CONTENT
    Meditation(
      id: 'spotify_meditation_music',
      title: 'Peaceful Meditation Music',
      description:
          'Calming instrumental music perfect for meditation and relaxation. Curated Spotify playlist for mindfulness practice.',
      category: 'Mindfulness',
      durationMinutes: 150,
      type: MeditationType.music,
      audioUrl:
          'https://open.spotify.com/playlist/37i9dQZF1DWZqd5JICZI0u?si=f4a83af6a0374b08',
      instructor: 'Spotify',
      tags: ['instrumental', 'ambient', 'relaxing', 'background'],
      difficulty: 1,
      createdAt: DateTime.now(),
    ),
    Meditation(
      id: 'spotify_sleep_sounds',
      title: 'Sleep Sounds and Ambient Noises',
      description:
          'Natural sleep sounds and ambient noises to help you fall asleep peacefully and stay asleep longer.',
      category: 'Sleep',
      durationMinutes: 240,
      type: MeditationType.nature,
      audioUrl:
          'https://open.spotify.com/artist/1zL2evr0Tl2KJcHaLUbwc5?si=lDdJsh9BRXGGDMkX9neZPQ',
      instructor: 'Sleep Sounds',
      tags: ['nature', 'rain', 'ocean', 'white noise'],
      difficulty: 1,
      createdAt: DateTime.now(),
    ),
    Meditation(
      id: 'spotify_mental_health_podcasts',
      title: 'Mental Health Podcast Collection',
      description:
          'Comprehensive mental health podcast playlist covering various topics, discussions, and expert insights.',
      category: 'Education',
      durationMinutes: 180,
      type: MeditationType.guided,
      audioUrl:
          'https://open.spotify.com/playlist/77AOjGgwOTmcDiH15lARCh?si=0f65cea2c2764213',
      instructor: 'Various Experts',
      tags: ['therapy', 'community', 'diversity', 'professional'],
      difficulty: 2,
      createdAt: DateTime.now(),
    ),
  ];
}
