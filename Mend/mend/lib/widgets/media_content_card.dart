import 'package:flutter/material.dart';
import '../models/media_content.dart';
import '../constants/app_constants.dart';

class MediaContentCard extends StatelessWidget {
  final MediaContent content;
  final VoidCallback? onTap;

  const MediaContentCard({super.key, required this.content, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              _buildThumbnail(),

              const SizedBox(width: AppConstants.paddingMedium),

              // Content info
              Expanded(child: _buildContentInfo(context)),

              // Action button
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: _getTypeColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        border: Border.all(
          color: _getTypeColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child:
          content.thumbnailUrl != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                child: Image.network(
                  content.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => _buildTypeIcon(),
                ),
              )
              : _buildTypeIcon(),
    );
  }

  Widget _buildTypeIcon() {
    return Center(
      child: Icon(_getTypeIcon(), color: _getTypeColor(), size: 24),
    );
  }

  Widget _buildContentInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and verification
        Row(
          children: [
            Expanded(
              child: Text(
                content.title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (content.isVerified)
              Container(
                margin: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.verified,
                  color: AppConstants.primaryColor,
                  size: 16,
                ),
              ),
          ],
        ),

        const SizedBox(height: 4),

        // Channel/Author
        if (content.channelName != null || content.author != null)
          Text(
            content.channelName ?? content.author!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppConstants.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        const SizedBox(height: 4),

        // Category and type
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getCategoryColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Text(
                content.categoryDisplayName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getCategoryColor(),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getTypeColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Text(
                content.typeDisplayName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getTypeColor(),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Stats
        Row(
          children: [
            Icon(Icons.schedule, size: 12, color: AppConstants.textSecondary),
            const SizedBox(width: 2),
            Text(
              content.formattedDuration,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.star, size: 12, color: Colors.amber),
            const SizedBox(width: 2),
            Text(
              content.rating.toStringAsFixed(1),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.textSecondary,
                fontSize: 11,
              ),
            ),
            if (content.viewCount > 0) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.visibility,
                size: 12,
                color: AppConstants.textSecondary,
              ),
              const SizedBox(width: 2),
              Text(
                content.formattedViewCount,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _getTypeColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Icon(Icons.play_arrow, color: _getTypeColor(), size: 20),
    );
  }

  IconData _getTypeIcon() {
    switch (content.type) {
      case MediaType.youtube:
        return Icons.play_circle_outline;
      case MediaType.spotify:
        return Icons.music_note;
      case MediaType.podcast:
        return Icons.podcasts;
      case MediaType.audiobook:
        return Icons.menu_book;
    }
  }

  Color _getTypeColor() {
    switch (content.type) {
      case MediaType.youtube:
        return const Color(0xFFFF0000); // YouTube Red
      case MediaType.spotify:
        return const Color(0xFF1DB954); // Spotify Green
      case MediaType.podcast:
        return const Color(0xFF9C27B0); // Purple
      case MediaType.audiobook:
        return const Color(0xFF795548); // Brown
    }
  }

  Color _getCategoryColor() {
    switch (content.category) {
      case MediaCategory.meditation:
        return AppConstants.primaryColor;
      case MediaCategory.anxiety:
        return const Color(0xFF9C27B0);
      case MediaCategory.depression:
        return const Color(0xFF3F51B5);
      case MediaCategory.stress:
        return const Color(0xFF00BCD4);
      case MediaCategory.sleep:
        return const Color(0xFF673AB7);
      case MediaCategory.mindfulness:
        return AppConstants.secondaryColor;
      case MediaCategory.selfCare:
        return const Color(0xFFE91E63);
      case MediaCategory.motivation:
        return const Color(0xFFFF6B35);
      case MediaCategory.therapy:
        return const Color(0xFF795548);
      case MediaCategory.education:
        return AppConstants.accentColor;
    }
  }
}
