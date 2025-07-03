import 'package:cloud_firestore/cloud_firestore.dart';

enum MediaType {
  youtube,
  spotify,
  podcast,
  audiobook,
}

enum MediaCategory {
  meditation,
  anxiety,
  depression,
  stress,
  sleep,
  mindfulness,
  selfCare,
  motivation,
  therapy,
  education,
}

class MediaContent {
  final String id;
  final String title;
  final String description;
  final MediaType type;
  final MediaCategory category;
  final String url;
  final String? thumbnailUrl;
  final String? channelName;
  final String? author;
  final int durationMinutes;
  final double rating;
  final int viewCount;
  final List<String> tags;
  final bool isVerified;
  final bool isProfessional;
  final DateTime createdAt;
  final DateTime updatedAt;

  MediaContent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.url,
    this.thumbnailUrl,
    this.channelName,
    this.author,
    required this.durationMinutes,
    this.rating = 0.0,
    this.viewCount = 0,
    this.tags = const [],
    this.isVerified = false,
    this.isProfessional = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'category': category.toString().split('.').last,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'channelName': channelName,
      'author': author,
      'durationMinutes': durationMinutes,
      'rating': rating,
      'viewCount': viewCount,
      'tags': tags,
      'isVerified': isVerified,
      'isProfessional': isProfessional,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory MediaContent.fromMap(Map<String, dynamic> map, String id) {
    return MediaContent(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: MediaType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => MediaType.youtube,
      ),
      category: MediaCategory.values.firstWhere(
        (e) => e.toString().split('.').last == map['category'],
        orElse: () => MediaCategory.meditation,
      ),
      url: map['url'] ?? '',
      thumbnailUrl: map['thumbnailUrl'],
      channelName: map['channelName'],
      author: map['author'],
      durationMinutes: map['durationMinutes'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      viewCount: map['viewCount'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
      isVerified: map['isVerified'] ?? false,
      isProfessional: map['isProfessional'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  MediaContent copyWith({
    String? id,
    String? title,
    String? description,
    MediaType? type,
    MediaCategory? category,
    String? url,
    String? thumbnailUrl,
    String? channelName,
    String? author,
    int? durationMinutes,
    double? rating,
    int? viewCount,
    List<String>? tags,
    bool? isVerified,
    bool? isProfessional,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MediaContent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      channelName: channelName ?? this.channelName,
      author: author ?? this.author,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      rating: rating ?? this.rating,
      viewCount: viewCount ?? this.viewCount,
      tags: tags ?? this.tags,
      isVerified: isVerified ?? this.isVerified,
      isProfessional: isProfessional ?? this.isProfessional,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get typeDisplayName {
    switch (type) {
      case MediaType.youtube:
        return 'YouTube';
      case MediaType.spotify:
        return 'Spotify';
      case MediaType.podcast:
        return 'Podcast';
      case MediaType.audiobook:
        return 'Audiobook';
    }
  }

  String get categoryDisplayName {
    switch (category) {
      case MediaCategory.meditation:
        return 'Meditation';
      case MediaCategory.anxiety:
        return 'Anxiety Relief';
      case MediaCategory.depression:
        return 'Depression Support';
      case MediaCategory.stress:
        return 'Stress Management';
      case MediaCategory.sleep:
        return 'Sleep & Relaxation';
      case MediaCategory.mindfulness:
        return 'Mindfulness';
      case MediaCategory.selfCare:
        return 'Self-Care';
      case MediaCategory.motivation:
        return 'Motivation';
      case MediaCategory.therapy:
        return 'Therapy & Counseling';
      case MediaCategory.education:
        return 'Mental Health Education';
    }
  }

  String get formattedDuration {
    if (durationMinutes < 60) {
      return '${durationMinutes}m';
    } else {
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
  }

  String get formattedViewCount {
    if (viewCount < 1000) {
      return viewCount.toString();
    } else if (viewCount < 1000000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    }
  }

  // Get YouTube video ID from URL
  String? get youtubeVideoId {
    if (type != MediaType.youtube) return null;
    
    final regex = RegExp(r'(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  // Get Spotify track/playlist ID from URL
  String? get spotifyId {
    if (type != MediaType.spotify) return null;
    
    final regex = RegExp(r'spotify\.com\/(track|playlist|album)\/([a-zA-Z0-9]+)');
    final match = regex.firstMatch(url);
    return match?.group(2);
  }

  // Check if content is suitable for beginners
  bool get isBeginnerFriendly {
    return tags.any((tag) => 
      tag.toLowerCase().contains('beginner') ||
      tag.toLowerCase().contains('intro') ||
      tag.toLowerCase().contains('basic') ||
      tag.toLowerCase().contains('gentle')
    );
  }

  // Check if content is for advanced users
  bool get isAdvanced {
    return tags.any((tag) => 
      tag.toLowerCase().contains('advanced') ||
      tag.toLowerCase().contains('deep') ||
      tag.toLowerCase().contains('intensive')
    );
  }
}

// Curated content collections
class MediaCollection {
  final String id;
  final String title;
  final String description;
  final MediaCategory category;
  final List<String> mediaIds;
  final String? thumbnailUrl;
  final bool isFeatured;
  final DateTime createdAt;

  const MediaCollection({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.mediaIds,
    this.thumbnailUrl,
    this.isFeatured = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category.toString().split('.').last,
      'mediaIds': mediaIds,
      'thumbnailUrl': thumbnailUrl,
      'isFeatured': isFeatured,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory MediaCollection.fromMap(Map<String, dynamic> map, String id) {
    return MediaCollection(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: MediaCategory.values.firstWhere(
        (e) => e.toString().split('.').last == map['category'],
        orElse: () => MediaCategory.meditation,
      ),
      mediaIds: List<String>.from(map['mediaIds'] ?? []),
      thumbnailUrl: map['thumbnailUrl'],
      isFeatured: map['isFeatured'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
