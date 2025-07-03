import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/media_content.dart';
import '../../data/media_content_data.dart';
import '../../constants/app_constants.dart';
import '../../widgets/media_content_card.dart';

class MediaLibraryScreen extends StatefulWidget {
  const MediaLibraryScreen({super.key});

  @override
  State<MediaLibraryScreen> createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends State<MediaLibraryScreen> {
  String _selectedCategory = 'All';
  String _selectedType = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          _buildFilters(),

          // Content
          Expanded(child: _buildContentList()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          // Category filter
          _buildCategoryFilter(),
          const SizedBox(height: AppConstants.paddingSmall),
          // Type filter
          _buildTypeFilter(),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = [
      'All',
      'Meditation',
      'Anxiety',
      'Depression',
      'Stress',
      'Sleep',
      'Mindfulness',
      'Therapy',
      'Education',
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : 'All';
                });
              },
              backgroundColor: Colors.grey.shade100,
              selectedColor: AppConstants.primaryColor.withValues(alpha: 0.2),
              checkmarkColor: AppConstants.primaryColor,
              labelStyle: TextStyle(
                color:
                    isSelected
                        ? AppConstants.primaryColor
                        : AppConstants.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color:
                    isSelected
                        ? AppConstants.primaryColor
                        : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeFilter() {
    final types = ['All', 'YouTube', 'Spotify', 'Podcast'];

    return Row(
      children:
          types.map((type) {
            final isSelected = _selectedType == type;
            return Padding(
              padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
              child: ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedType = selected ? type : 'All';
                  });
                },
                backgroundColor: Colors.grey.shade100,
                selectedColor: AppConstants.secondaryColor.withValues(
                  alpha: 0.2,
                ),
                labelStyle: TextStyle(
                  color:
                      isSelected
                          ? AppConstants.secondaryColor
                          : AppConstants.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(
                  color:
                      isSelected
                          ? AppConstants.secondaryColor
                          : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildContentList() {
    final filteredContent = _getFilteredContent();

    if (filteredContent.isEmpty) {
      return _buildEmptyState();
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
            onTap: () => _openContent(content),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 80,
              color: AppConstants.textSecondary,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No results found'
                  : 'No content available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms or filters.'
                  : 'Media content will appear here.',
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

  List<MediaContent> _getFilteredContent() {
    var content = MediaContentData.curatedContent;

    // Filter by category
    if (_selectedCategory != 'All') {
      final categoryMap = {
        'Meditation': MediaCategory.meditation,
        'Anxiety': MediaCategory.anxiety,
        'Depression': MediaCategory.depression,
        'Stress': MediaCategory.stress,
        'Sleep': MediaCategory.sleep,
        'Mindfulness': MediaCategory.mindfulness,
        'Therapy': MediaCategory.therapy,
        'Education': MediaCategory.education,
      };

      final category = categoryMap[_selectedCategory];
      if (category != null) {
        content = content.where((item) => item.category == category).toList();
      }
    }

    // Filter by type
    if (_selectedType != 'All') {
      final typeMap = {
        'YouTube': MediaType.youtube,
        'Spotify': MediaType.spotify,
        'Podcast': MediaType.podcast,
      };

      final type = typeMap[_selectedType];
      if (type != null) {
        content = content.where((item) => item.type == type).toList();
      }
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      content = MediaContentData.searchContent(_searchQuery);
    }

    // Sort by rating and verification
    content.sort((a, b) {
      if (a.isVerified && !b.isVerified) return -1;
      if (!a.isVerified && b.isVerified) return 1;
      return b.rating.compareTo(a.rating);
    });

    return content;
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Search Media Content'),
            content: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search videos, podcasts, music...',
                prefixIcon: Icon(Icons.search),
              ),
              autofocus: true,
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
                Navigator.of(context).pop();
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = _searchController.text.trim();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Search'),
              ),
            ],
          ),
    );
  }

  void _openContent(MediaContent content) async {
    try {
      String urlToOpen = content.url;

      // Handle different content types with appropriate URL schemes
      switch (content.type) {
        case MediaType.youtube:
          // Extract video ID from YouTube URL
          final videoId = _extractYouTubeVideoId(content.url);
          if (videoId != null) {
            final youtubeAppUrl = 'youtube://watch?v=$videoId';

            try {
              final appUri = Uri.parse(youtubeAppUrl);
              if (await canLaunchUrl(appUri)) {
                await launchUrl(appUri, mode: LaunchMode.externalApplication);
                return;
              }
            } catch (e) {
              // Fallback to web URL
              urlToOpen = content.url;
            }
          }
          break;

        case MediaType.spotify:
          // Extract Spotify ID from URL and try app first
          final spotifyId = _extractSpotifyId(content.url);
          if (spotifyId != null) {
            String spotifyAppUrl;
            if (content.url.contains('/playlist/')) {
              spotifyAppUrl = 'spotify:playlist:$spotifyId';
            } else if (content.url.contains('/artist/')) {
              spotifyAppUrl = 'spotify:artist:$spotifyId';
            } else if (content.url.contains('/album/')) {
              spotifyAppUrl = 'spotify:album:$spotifyId';
            } else {
              spotifyAppUrl = 'spotify:track:$spotifyId';
            }

            try {
              final appUri = Uri.parse(spotifyAppUrl);
              if (await canLaunchUrl(appUri)) {
                await launchUrl(appUri, mode: LaunchMode.externalApplication);
                return;
              }
            } catch (e) {
              // Fallback to web URL
              urlToOpen = content.url;
            }
          }
          break;

        case MediaType.podcast:
        case MediaType.audiobook:
          // Use the original URL for podcasts and audiobooks
          urlToOpen = content.url;
          break;
      }

      // Launch the URL
      final uri = Uri.parse(urlToOpen);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Opening ${content.title} in ${content.typeDisplayName}',
              ),
              backgroundColor: AppConstants.successColor,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not open ${content.typeDisplayName}. Please install the app or try again.',
              ),
              backgroundColor: AppConstants.warningColor,
              action: SnackBarAction(
                label: 'Copy Link',
                onPressed: () {
                  // Copy URL to clipboard as fallback
                  // You could implement clipboard functionality here
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening content. Please try again.'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  String? _extractYouTubeVideoId(String url) {
    // Handle different YouTube URL formats
    final patterns = [
      RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]+)'),
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]+)'),
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]+)'),
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
    // Handle different Spotify URL formats
    final patterns = [
      RegExp(r'spotify\.com/playlist/([a-zA-Z0-9]+)'),
      RegExp(r'spotify\.com/artist/([a-zA-Z0-9]+)'),
      RegExp(r'spotify\.com/album/([a-zA-Z0-9]+)'),
      RegExp(r'spotify\.com/track/([a-zA-Z0-9]+)'),
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
