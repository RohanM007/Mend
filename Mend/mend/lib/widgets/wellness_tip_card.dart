import 'package:flutter/material.dart';
import '../models/wellness_content.dart';
import '../constants/app_constants.dart';

class WellnessTipCard extends StatelessWidget {
  final WellnessTip tip;
  final VoidCallback? onTap;

  const WellnessTipCard({
    super.key,
    required this.tip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap ?? () => _showFullTip(context),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(tip.category).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: Icon(
                      _getCategoryIcon(tip.category),
                      color: _getCategoryColor(tip.category),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.categoryDisplayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getCategoryColor(tip.category),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${tip.readingTimeMinutes} min read',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppConstants.textSecondary,
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Title
              Text(
                tip.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: AppConstants.paddingSmall),
              
              // Preview content
              Text(
                _getPreviewContent(tip.content),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppConstants.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Tags
              if (tip.tags.isNotEmpty)
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: tip.tags.take(3).map((tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(tip.category).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: Text(
                      tag,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getCategoryColor(tip.category),
                        fontSize: 10,
                      ),
                    ),
                  )).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPreviewContent(String content) {
    // Remove bullet points and formatting for preview
    final cleanContent = content
        .replaceAll('•', '')
        .replaceAll('\n', ' ')
        .trim();
    
    if (cleanContent.length > 120) {
      return '${cleanContent.substring(0, 120)}...';
    }
    return cleanContent;
  }

  IconData _getCategoryIcon(WellnessCategory category) {
    switch (category) {
      case WellnessCategory.motivation:
        return Icons.rocket_launch;
      case WellnessCategory.selfLove:
        return Icons.favorite;
      case WellnessCategory.mindfulness:
        return Icons.psychology;
      case WellnessCategory.resilience:
        return Icons.shield;
      case WellnessCategory.gratitude:
        return Icons.volunteer_activism;
      case WellnessCategory.stress:
        return Icons.spa;
      case WellnessCategory.anxiety:
        return Icons.air;
      case WellnessCategory.sleep:
        return Icons.bedtime;
      case WellnessCategory.productivity:
        return Icons.trending_up;
      case WellnessCategory.relationships:
        return Icons.people;
    }
  }

  Color _getCategoryColor(WellnessCategory category) {
    switch (category) {
      case WellnessCategory.motivation:
        return const Color(0xFFFF6B35);
      case WellnessCategory.selfLove:
        return const Color(0xFFE91E63);
      case WellnessCategory.mindfulness:
        return AppConstants.secondaryColor;
      case WellnessCategory.resilience:
        return const Color(0xFF795548);
      case WellnessCategory.gratitude:
        return AppConstants.accentColor;
      case WellnessCategory.stress:
        return const Color(0xFF00BCD4);
      case WellnessCategory.anxiety:
        return AppConstants.primaryColor;
      case WellnessCategory.sleep:
        return const Color(0xFF673AB7);
      case WellnessCategory.productivity:
        return const Color(0xFFFF9800);
      case WellnessCategory.relationships:
        return const Color(0xFF9C27B0);
    }
  }

  void _showFullTip(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(tip.category).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            ),
                            child: Icon(
                              _getCategoryIcon(tip.category),
                              color: _getCategoryColor(tip.category),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tip.categoryDisplayName,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: _getCategoryColor(tip.category),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${tip.readingTimeMinutes} min read',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppConstants.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      // Title
                      Text(
                        tip.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      // Content
                      Text(
                        tip.content,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      // Tags
                      if (tip.tags.isNotEmpty) ...[
                        Text(
                          'Tags',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tip.tags.map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(tip.category).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                            ),
                            child: Text(
                              tag,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getCategoryColor(tip.category),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
