import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CrisisResourcesCard extends StatelessWidget {
  final VoidCallback? onTap;

  const CrisisResourcesCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.errorColor.withValues(alpha: 0.1),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppConstants.errorColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: const Icon(
                  Icons.emergency,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crisis Resources',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.errorColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Need immediate help? Access 24/7 crisis support.',
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
                color: AppConstants.errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
