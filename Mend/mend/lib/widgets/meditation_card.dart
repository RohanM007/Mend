import 'package:flutter/material.dart';
import '../models/meditation.dart';
import '../constants/app_constants.dart';

class MeditationCard extends StatelessWidget {
  final Meditation meditation;
  final VoidCallback? onTap;

  const MeditationCard({
    super.key,
    required this.meditation,
    this.onTap,
  });

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
            children: [
              // Meditation image/icon
              _buildMeditationIcon(context),
              
              const SizedBox(width: AppConstants.paddingMedium),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and premium badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            meditation.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (meditation.isPremium)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                            ),
                            child: Text(
                              'PRO',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.paddingSmall),
                    
                    // Description
                    Text(
                      meditation.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: AppConstants.paddingSmall),
                    
                    // Metadata row
                    Row(
                      children: [
                        // Duration
                        _buildMetadataChip(
                          context,
                          Icons.schedule,
                          meditation.formattedDuration,
                        ),
                        
                        const SizedBox(width: AppConstants.paddingSmall),
                        
                        // Difficulty
                        _buildMetadataChip(
                          context,
                          Icons.signal_cellular_alt,
                          meditation.difficultyText,
                        ),
                        
                        const SizedBox(width: AppConstants.paddingSmall),
                        
                        // Type
                        _buildMetadataChip(
                          context,
                          _getTypeIcon(meditation.type),
                          meditation.typeDisplayName,
                        ),
                      ],
                    ),
                    
                    // Instructor
                    if (meditation.instructor != null) ...[
                      const SizedBox(height: AppConstants.paddingSmall),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 14,
                            color: AppConstants.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            meditation.instructor!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppConstants.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Play button
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationIcon(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: _getCategoryColor(meditation.category).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Icon(
        _getCategoryIcon(meditation.category),
        color: _getCategoryColor(meditation.category),
        size: 30,
      ),
    );
  }

  Widget _buildMetadataChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppConstants.textSecondary,
          ),
          const SizedBox(width: 2),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppConstants.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'stress relief':
        return Icons.spa;
      case 'sleep':
        return Icons.bedtime;
      case 'anxiety':
        return Icons.psychology;
      case 'grounding':
        return Icons.nature;
      case 'self-compassion':
        return Icons.favorite;
      case 'mindfulness':
        return Icons.visibility;
      case 'breathing':
        return Icons.air;
      case 'body scan':
        return Icons.accessibility_new;
      default:
        return Icons.self_improvement;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'stress relief':
        return const Color(0xFF4CAF50);
      case 'sleep':
        return const Color(0xFF3F51B5);
      case 'anxiety':
        return const Color(0xFF9C27B0);
      case 'grounding':
        return const Color(0xFF795548);
      case 'self-compassion':
        return const Color(0xFFE91E63);
      case 'mindfulness':
        return const Color(0xFF00BCD4);
      case 'breathing':
        return const Color(0xFF2196F3);
      case 'body scan':
        return const Color(0xFFFF9800);
      default:
        return AppConstants.primaryColor;
    }
  }

  IconData _getTypeIcon(MeditationType type) {
    switch (type) {
      case MeditationType.guided:
        return Icons.record_voice_over;
      case MeditationType.music:
        return Icons.music_note;
      case MeditationType.nature:
        return Icons.nature_people;
      case MeditationType.breathing:
        return Icons.air;
    }
  }
}

class MeditationListTile extends StatelessWidget {
  final Meditation meditation;
  final VoidCallback? onTap;

  const MeditationListTile({
    super.key,
    required this.meditation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getCategoryColor(meditation.category).withValues(alpha: 0.1),
        child: Icon(
          _getCategoryIcon(meditation.category),
          color: _getCategoryColor(meditation.category),
        ),
      ),
      title: Text(
        meditation.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meditation.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                meditation.formattedDuration,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.textSecondary,
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                meditation.difficultyText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: meditation.isPremium
          ? const Icon(Icons.star, color: Colors.amber)
          : const Icon(Icons.play_arrow),
      onTap: onTap,
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'stress relief':
        return Icons.spa;
      case 'sleep':
        return Icons.bedtime;
      case 'anxiety':
        return Icons.psychology;
      case 'grounding':
        return Icons.nature;
      case 'self-compassion':
        return Icons.favorite;
      case 'mindfulness':
        return Icons.visibility;
      case 'breathing':
        return Icons.air;
      case 'body scan':
        return Icons.accessibility_new;
      default:
        return Icons.self_improvement;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'stress relief':
        return const Color(0xFF4CAF50);
      case 'sleep':
        return const Color(0xFF3F51B5);
      case 'anxiety':
        return const Color(0xFF9C27B0);
      case 'grounding':
        return const Color(0xFF795548);
      case 'self-compassion':
        return const Color(0xFFE91E63);
      case 'mindfulness':
        return const Color(0xFF00BCD4);
      case 'breathing':
        return const Color(0xFF2196F3);
      case 'body scan':
        return const Color(0xFFFF9800);
      default:
        return AppConstants.primaryColor;
    }
  }
}
