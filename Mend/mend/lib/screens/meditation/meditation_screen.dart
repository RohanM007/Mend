import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/media_content.dart';
import '../../data/media_content_data.dart';
import '../../constants/app_constants.dart';
import '../../widgets/media_content_card.dart';
import '../../widgets/meditation_category_chip.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Category filter
          _buildCategoryFilter(),

          // Media content list
          Expanded(child: _buildMediaContentList()),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = [
      'All',
      'Anxiety',
      'Depression',
      'Stress',
      'Sleep',
      'Meditation',
      'Education',
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
            child: MeditationCategoryChip(
              category: category,
              isSelected: _selectedCategory == category,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaContentList() {
    final filteredContent = _getFilteredMediaContent();

    if (filteredContent.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: filteredContent.length,
      itemBuilder: (context, index) {
        final content = filteredContent[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
          child: MediaContentCard(
            content: content,
            onTap: () => _openMediaContent(content),
          ),
        );
      },
    );
  }

  List<MediaContent> _getFilteredMediaContent() {
    var content = MediaContentData.curatedContent;

    // Filter by category
    if (_selectedCategory != 'All') {
      final categoryMap = {
        'Meditation': MediaCategory.meditation,
        'Anxiety': MediaCategory.anxiety,
        'Depression': MediaCategory.depression,
        'Stress': MediaCategory.stress,
        'Sleep': MediaCategory.sleep,
        'Education': MediaCategory.education,
      };

      final category = categoryMap[_selectedCategory];
      if (category != null) {
        content = content.where((item) => item.category == category).toList();
      }
    }

    // Sort by rating and verification
    content.sort((a, b) {
      if (a.isVerified && !b.isVerified) return -1;
      if (!a.isVerified && b.isVerified) return 1;
      return b.rating.compareTo(a.rating);
    });

    return content;
  }

  void _openMediaContent(MediaContent content) async {
    try {
      String urlToOpen = content.url;
      debugPrint('Opening content: ${content.title}');
      debugPrint('Original URL: ${content.url}');

      // Handle YouTube URLs
      if (content.url.contains('youtube.com') ||
          content.url.contains('youtu.be')) {
        final videoId = _extractYouTubeVideoId(content.url);
        debugPrint('Extracted YouTube video ID: $videoId');

        if (videoId != null) {
          final youtubeAppUrl = 'youtube://watch?v=$videoId';
          debugPrint('Trying YouTube app URL: $youtubeAppUrl');

          try {
            final appUri = Uri.parse(youtubeAppUrl);
            if (await canLaunchUrl(appUri)) {
              debugPrint('Opening in YouTube app');
              await launchUrl(appUri, mode: LaunchMode.externalApplication);
              return;
            }
          } catch (e) {
            debugPrint('YouTube app failed, falling back to web: $e');
            urlToOpen = content.url;
          }
        }
      }
      // Handle Spotify URLs
      else if (content.url.contains('spotify.com')) {
        final spotifyId = _extractSpotifyId(content.url);
        debugPrint('Extracted Spotify ID: $spotifyId');

        if (spotifyId != null) {
          String spotifyAppUrl;
          if (content.url.contains('/playlist/')) {
            spotifyAppUrl = 'spotify:playlist:$spotifyId';
          } else if (content.url.contains('/artist/')) {
            spotifyAppUrl = 'spotify:artist:$spotifyId';
          } else {
            spotifyAppUrl = 'spotify:track:$spotifyId';
          }

          debugPrint('Trying Spotify app URL: $spotifyAppUrl');

          try {
            final appUri = Uri.parse(spotifyAppUrl);
            if (await canLaunchUrl(appUri)) {
              debugPrint('Opening in Spotify app');
              await launchUrl(appUri, mode: LaunchMode.externalApplication);
              return;
            }
          } catch (e) {
            debugPrint('Spotify app failed, falling back to web: $e');
            urlToOpen = content.url;
          }
        }
      }

      // Launch the URL in browser/app
      final uri = Uri.parse(urlToOpen);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening ${content.title}'),
              backgroundColor: AppConstants.successColor,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Could not open content. Please install the app or try again.',
              ),
              backgroundColor: AppConstants.warningColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening content: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.self_improvement_outlined,
              size: 80,
              color: AppConstants.textSecondary,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              'No meditations found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              _selectedCategory == 'All'
                  ? 'Meditations will appear here once loaded.'
                  : 'No meditations found in the $_selectedCategory category.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String? _extractYouTubeVideoId(String url) {
    final patterns = [
      RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]+)'),
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]+)(?:\?.*)?'),
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]+)(?:\?.*)?'),
      RegExp(
        r'youtube\.com/watch\?.*v=([a-zA-Z0-9_-]+)',
      ), // Handle v= anywhere in query string
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null) {
        return match.group(1);
      }
    }
    return null;
  }

  String? _extractSpotifyId(String url) {
    final patterns = [
      RegExp(r'spotify\.com/playlist/([a-zA-Z0-9]+)(?:\?.*)?'),
      RegExp(r'spotify\.com/artist/([a-zA-Z0-9]+)(?:\?.*)?'),
      RegExp(r'spotify\.com/album/([a-zA-Z0-9]+)(?:\?.*)?'),
      RegExp(r'spotify\.com/track/([a-zA-Z0-9]+)(?:\?.*)?'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null) {
        return match.group(1);
      }
    }
    return null;
  }
}
