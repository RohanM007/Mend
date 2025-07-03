import 'package:flutter/material.dart';
import '../models/mental_health_info.dart';
import '../constants/app_constants.dart';

class MentalHealthCard extends StatelessWidget {
  final MentalHealthInfo info;
  final VoidCallback? onTap;

  const MentalHealthCard({
    super.key,
    required this.info,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and category
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(info.category).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: Icon(
                      _getCategoryIcon(info.category),
                      color: _getCategoryColor(info.category),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.categoryDisplayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getCategoryColor(info.category),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          info.contentTypeDisplayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (info.isEmergencyInfo)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.errorColor,
                        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: Text(
                        'URGENT',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Title
              Text(
                info.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppConstants.paddingSmall),

              // Description
              Text(
                info.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppConstants.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Key symptoms (first 3)
              if (info.symptoms.isNotEmpty) ...[
                Text(
                  'Key Signs:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                ...info.symptoms.take(3).map((symptom) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.only(top: 8, right: 8),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(info.category),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          symptom,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppConstants.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
                if (info.symptoms.length > 3)
                  Text(
                    '+${info.symptoms.length - 3} more',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getCategoryColor(info.category),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],

              const SizedBox(height: AppConstants.paddingMedium),

              // Footer with reading time and arrow
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: AppConstants.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${info.readingTimeMinutes} min read',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppConstants.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(MentalHealthCategory category) {
    switch (category) {
      case MentalHealthCategory.anxiety:
        return Icons.psychology;
      case MentalHealthCategory.depression:
        return Icons.sentiment_very_dissatisfied;
      case MentalHealthCategory.bipolar:
        return Icons.mood;
      case MentalHealthCategory.ptsd:
        return Icons.shield;
      case MentalHealthCategory.ocd:
        return Icons.refresh;
      case MentalHealthCategory.adhd:
        return Icons.flash_on;
      case MentalHealthCategory.eatingDisorders:
        return Icons.restaurant;
      case MentalHealthCategory.substanceAbuse:
        return Icons.local_pharmacy;
      case MentalHealthCategory.personalityDisorders:
        return Icons.person;
      case MentalHealthCategory.schizophrenia:
        return Icons.visibility_off;
      case MentalHealthCategory.generalWellness:
        return Icons.favorite;
    }
  }

  Color _getCategoryColor(MentalHealthCategory category) {
    switch (category) {
      case MentalHealthCategory.anxiety:
        return const Color(0xFF9C27B0); // Purple
      case MentalHealthCategory.depression:
        return const Color(0xFF3F51B5); // Indigo
      case MentalHealthCategory.bipolar:
        return const Color(0xFFFF9800); // Orange
      case MentalHealthCategory.ptsd:
        return const Color(0xFF795548); // Brown
      case MentalHealthCategory.ocd:
        return const Color(0xFF00BCD4); // Cyan
      case MentalHealthCategory.adhd:
        return const Color(0xFFFFEB3B); // Yellow
      case MentalHealthCategory.eatingDisorders:
        return const Color(0xFFE91E63); // Pink
      case MentalHealthCategory.substanceAbuse:
        return const Color(0xFF607D8B); // Blue Grey
      case MentalHealthCategory.personalityDisorders:
        return const Color(0xFF673AB7); // Deep Purple
      case MentalHealthCategory.schizophrenia:
        return const Color(0xFF424242); // Grey
      case MentalHealthCategory.generalWellness:
        return const Color(0xFF4CAF50); // Green
    }
  }
}
