import '../models/media_content.dart';

class MediaContentData {
  static List<MediaContent> get curatedContent => [
    // ANXIETY RELIEF CONTENT
    MediaContent(
      id: 'yt_anxiety_1',
      title: 'How to Spot Normal Anxiety VS Anxiety Disorders',
      description:
          'Professional explanation of the difference between normal anxiety and anxiety disorders. Educational content from mental health experts.',
      type: MediaType.youtube,
      category: MediaCategory.anxiety,
      url: 'https://www.youtube.com/watch?v=T4E2JzmIraw',
      thumbnailUrl: 'https://img.youtube.com/vi/T4E2JzmIraw/maxresdefault.jpg',
      channelName: 'MedCircle',
      durationMinutes: 23,
      rating: 4.9,
      viewCount: 1670000,
      tags: ['anxiety', 'education', 'professional', 'mental health'],
      isVerified: true,
      isProfessional: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    MediaContent(
      id: 'yt_anxiety_2',
      title: 'GUIDED MEDITATION - Anxiety Relief',
      description:
          'A calming guided meditation specifically designed to help relieve anxiety and promote relaxation.',
      type: MediaType.youtube,
      category: MediaCategory.anxiety,
      url: 'https://www.youtube.com/watch?v=8_jcEpwKQXc',
      thumbnailUrl: 'https://img.youtube.com/vi/8_jcEpwKQXc/maxresdefault.jpg',
      channelName: 'The Honest Guys - Meditations - Relaxation',
      durationMinutes: 13,
      rating: 4.8,
      viewCount: 2500000,
      tags: ['anxiety', 'guided meditation', 'relaxation', 'calming'],
      isVerified: true,
      isProfessional: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // DEPRESSION SUPPORT CONTENT
    MediaContent(
      id: 'yt_depression_1',
      title:
          'Guided Meditation for Detachment From Over-Thinking (Anxiety / OCD / Depression)',
      description:
          'A comprehensive guided meditation by Michael Sealey to help detach from overthinking patterns associated with anxiety, OCD, and depression.',
      type: MediaType.youtube,
      category: MediaCategory.depression,
      url: 'https://www.youtube.com/watch?v=1vx8iUvfyCY',
      thumbnailUrl: 'https://img.youtube.com/vi/1vx8iUvfyCY/maxresdefault.jpg',
      channelName: 'Michael Sealey',
      durationMinutes: 43,
      rating: 4.8,
      viewCount: 3500000,
      tags: [
        'depression',
        'overthinking',
        'anxiety',
        'OCD',
        'guided meditation',
      ],
      isVerified: true,
      isProfessional: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    MediaContent(
      id: 'yt_depression_2',
      title: 'What is depression? - Helen M. Farrell',
      description:
          'TED-Ed educational video explaining what depression is, its symptoms, and how it affects the brain. Presented by Helen M. Farrell.',
      type: MediaType.youtube,
      category: MediaCategory.education,
      url: 'https://www.youtube.com/watch?v=z-IR48Mb3W0',
      thumbnailUrl: 'https://img.youtube.com/vi/z-IR48Mb3W0/maxresdefault.jpg',
      channelName: 'TED-Ed',
      durationMinutes: 5,
      rating: 4.9,
      viewCount: 8500000,
      tags: ['depression', 'education', 'TED-Ed', 'mental health'],
      isVerified: true,
      isProfessional: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // STRESS MANAGEMENT CONTENT
    MediaContent(
      id: 'yt_stress_1',
      title:
          'De-stress in 5 Minutes: A Free Mind and Body Meditation with Elisha Mudly',
      description:
          'Quick and effective stress relief meditation for busy schedules. Guided by Elisha Mudly from Headspace.',
      type: MediaType.youtube,
      category: MediaCategory.stress,
      url: 'https://www.youtube.com/watch?v=wE292vsJcBY',
      thumbnailUrl: 'https://img.youtube.com/vi/wE292vsJcBY/maxresdefault.jpg',
      channelName: 'Headspace',
      durationMinutes: 5,
      rating: 4.9,
      viewCount: 5600000,
      tags: ['stress', 'quick', 'meditation', 'mindfulness'],
      isVerified: true,
      isProfessional: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // SLEEP & RELAXATION CONTENT
    MediaContent(
      id: 'yt_sleep_1',
      title:
          'Guided Sleep Meditation: The Haven of Peace. Ultra Deep Relaxation. Dark Screen',
      description:
          'A soothing guided sleep meditation designed to help you fall asleep quickly with ultra deep relaxation. Features a dark screen for better sleep.',
      type: MediaType.youtube,
      category: MediaCategory.sleep,
      url: 'https://www.youtube.com/watch?v=TP2gb2fSYXY',
      thumbnailUrl: 'https://img.youtube.com/vi/TP2gb2fSYXY/maxresdefault.jpg',
      channelName: 'The Honest Guys - Meditations - Relaxation',
      durationMinutes: 13,
      rating: 4.9,
      viewCount: 5600000,
      tags: ['sleep', 'deep relaxation', 'dark screen', 'guided meditation'],
      isVerified: true,
      isProfessional: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // MINDFULNESS CONTENT
    MediaContent(
      id: 'yt_mindfulness_1',
      title: 'Mindfulness Meditation for Beginners',
      description:
          'Learn the basics of mindfulness meditation with this gentle introduction.',
      type: MediaType.youtube,
      category: MediaCategory.mindfulness,
      url: 'https://youtu.be/ZToicYcHIOU',
      thumbnailUrl: 'https://img.youtube.com/vi/ZToicYcHIOU/maxresdefault.jpg',
      channelName: 'Mindful Movement',
      durationMinutes: 12,
      rating: 4.7,
      viewCount: 2100000,
      tags: ['mindfulness', 'beginner', 'awareness', 'present'],
      isVerified: true,
      isProfessional: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // THERAPY & COUNSELING CONTENT
    MediaContent(
      id: 'yt_therapy_1',
      title: 'Cognitive Behavioral Therapy (CBT) Explained',
      description:
          'Understanding CBT techniques and how they can help with mental health challenges.',
      type: MediaType.youtube,
      category: MediaCategory.therapy,
      url: 'https://youtu.be/0ViaCs0k2jM',
      thumbnailUrl: 'https://img.youtube.com/vi/0ViaCs0k2jM/maxresdefault.jpg',
      channelName: 'Therapy in a Nutshell',
      durationMinutes: 18,
      rating: 4.9,
      viewCount: 1500000,
      tags: ['CBT', 'therapy', 'techniques', 'professional'],
      isVerified: true,
      isProfessional: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // SPOTIFY CONTENT (Meditation Playlists)
    MediaContent(
      id: 'spotify_meditation_1',
      title: 'Peaceful meditation',
      description:
          'Calming instrumental music perfect for meditation and relaxation. Curated Spotify playlist for mindfulness practice.',
      type: MediaType.spotify,
      category: MediaCategory.meditation,
      url:
          'https://open.spotify.com/playlist/37i9dQZF1DWZqd5JICZI0u?si=f4a83af6a0374b08',
      channelName: 'Spotify',
      durationMinutes: 150,
      rating: 4.7,
      viewCount: 1500000,
      tags: ['instrumental', 'ambient', 'relaxing', 'background'],
      isVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    MediaContent(
      id: 'spotify_sleep_1',
      title: 'Sleep Sounds and ambient noises',
      description:
          'Natural sleep sounds and ambient noises to help you fall asleep peacefully and stay asleep longer.',
      type: MediaType.spotify,
      category: MediaCategory.sleep,
      url:
          'https://open.spotify.com/artist/1zL2evr0Tl2KJcHaLUbwc5?si=lDdJsh9BRXGGDMkX9neZPQ',
      channelName: 'Sleep Sounds and ambient noises',
      durationMinutes: 240,
      rating: 4.8,
      viewCount: 2500000,
      tags: ['nature', 'rain', 'ocean', 'white noise'],
      isVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // PODCAST CONTENT
    MediaContent(
      id: 'podcast_therapy_1',
      title: 'Mental Health Podcast',
      description:
          'Comprehensive mental health podcast playlist covering various topics, discussions, and expert insights.',
      type: MediaType.podcast,
      category: MediaCategory.therapy,
      url:
          'https://open.spotify.com/playlist/77AOjGgwOTmcDiH15lARCh?si=0f65cea2c2764213',
      channelName: 'Mental Health Podcast Playlist',
      author: 'Various Mental Health Experts',
      durationMinutes: 180,
      rating: 4.8,
      viewCount: 500000,
      tags: ['therapy', 'community', 'diversity', 'professional'],
      isVerified: true,
      isProfessional: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  static List<MediaCollection> get featuredCollections => [
    MediaCollection(
      id: 'collection_anxiety_relief',
      title: 'Anxiety Relief Toolkit',
      description:
          'Comprehensive resources for understanding and managing anxiety.',
      category: MediaCategory.anxiety,
      mediaIds: ['yt_anxiety_1', 'yt_anxiety_2'],
      isFeatured: true,
      createdAt: DateTime.now(),
    ),

    MediaCollection(
      id: 'collection_sleep_better',
      title: 'Better Sleep Collection',
      description:
          'Meditations, music, and sounds to improve your sleep quality.',
      category: MediaCategory.sleep,
      mediaIds: ['yt_sleep_1', 'spotify_sleep_1'],
      isFeatured: true,
      createdAt: DateTime.now(),
    ),

    MediaCollection(
      id: 'collection_mindfulness_basics',
      title: 'Mindfulness for Beginners',
      description:
          'Start your mindfulness journey with these beginner-friendly resources.',
      category: MediaCategory.mindfulness,
      mediaIds: ['spotify_meditation_1', 'yt_stress_1'],
      isFeatured: true,
      createdAt: DateTime.now(),
    ),

    MediaCollection(
      id: 'collection_professional_help',
      title: 'Mental Health Resources',
      description:
          'Professional mental health content including podcasts and educational videos.',
      category: MediaCategory.therapy,
      mediaIds: ['podcast_therapy_1', 'yt_depression_2'],
      isFeatured: true,
      createdAt: DateTime.now(),
    ),
  ];

  // Get content by category
  static List<MediaContent> getContentByCategory(MediaCategory category) {
    return curatedContent
        .where((content) => content.category == category)
        .toList();
  }

  // Get content by type
  static List<MediaContent> getContentByType(MediaType type) {
    return curatedContent.where((content) => content.type == type).toList();
  }

  // Get featured content
  static List<MediaContent> getFeaturedContent() {
    return curatedContent
        .where((content) => content.isVerified && content.rating >= 4.5)
        .toList();
  }

  // Get beginner-friendly content
  static List<MediaContent> getBeginnerContent() {
    return curatedContent
        .where((content) => content.isBeginnerFriendly)
        .toList();
  }

  // Search content
  static List<MediaContent> searchContent(String query) {
    final lowerQuery = query.toLowerCase();
    return curatedContent.where((content) {
      return content.title.toLowerCase().contains(lowerQuery) ||
          content.description.toLowerCase().contains(lowerQuery) ||
          content.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          content.channelName?.toLowerCase().contains(lowerQuery) == true;
    }).toList();
  }
}
