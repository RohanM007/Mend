import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/wellness_content.dart';
import '../constants/app_constants.dart';

class AffirmationCard extends StatelessWidget {
  final Affirmation affirmation;
  final VoidCallback? onTap;

  const AffirmationCard({
    super.key,
    required this.affirmation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppConstants.lightBlue,
              AppConstants.lightGreen,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: AppConstants.primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Expanded(
                      child: Text(
                        affirmation.categoryDisplayName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, size: 20),
                      onPressed: () => _shareAffirmation(context),
                      color: AppConstants.primaryColor,
                    ),
                  ],
                ),
                
                const SizedBox(height: AppConstants.paddingMedium),
                
                // Affirmation text
                Text(
                  affirmation.text,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: AppConstants.paddingMedium),
                
                // Footer
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: AppConstants.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Daily Affirmation',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppConstants.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    if (affirmation.author != null)
                      Text(
                        '— ${affirmation.author}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _shareAffirmation(BuildContext context) {
    final shareText = '''
${affirmation.text}

${affirmation.author != null ? '— ${affirmation.author}' : ''}

Daily affirmation from ${AppConstants.appName}
''';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Affirmation copied to clipboard'),
        backgroundColor: AppConstants.successColor,
      ),
    );
  }
}
