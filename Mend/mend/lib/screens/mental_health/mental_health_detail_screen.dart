import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/mental_health_info.dart';
import '../../constants/app_constants.dart';
import 'crisis_resources_screen.dart';

class MentalHealthDetailScreen extends StatelessWidget {
  final MentalHealthInfo info;

  const MentalHealthDetailScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(info.categoryDisplayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareInfo(context),
          ),
          if (info.isEmergencyInfo ||
              info.category == MentalHealthCategory.generalWellness)
            IconButton(
              icon: const Icon(Icons.emergency, color: AppConstants.errorColor),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CrisisResourcesScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),

            const SizedBox(height: AppConstants.paddingLarge),

            // Main content
            _buildMainContent(context),

            // Symptoms section
            if (info.symptoms.isNotEmpty) _buildSymptomsSection(context),

            // Treatments section
            if (info.treatments.isNotEmpty) _buildTreatmentsSection(context),

            // Self-care section
            if (info.selfCareStrategies.isNotEmpty)
              _buildSelfCareSection(context),

            // Warning signs section
            if (info.warningSignsToSeekHelp.isNotEmpty)
              _buildWarningSignsSection(context),

            // Resources section
            if (info.resources.isNotEmpty) _buildResourcesSection(context),

            const SizedBox(height: AppConstants.paddingLarge),

            // Disclaimer
            _buildDisclaimer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getCategoryColor(info.category).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Icon(
                _getCategoryIcon(info.category),
                color: _getCategoryColor(info.category),
                size: 30,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Text(
          info.description,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppConstants.textSecondary),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Text(
          info.content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildSymptomsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.paddingXLarge),
        Text(
          'Common Signs & Symptoms',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        ...info.symptoms.map(
          (symptom) =>
              _buildListItem(context, symptom, Icons.check_circle_outline),
        ),
      ],
    );
  }

  Widget _buildTreatmentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.paddingXLarge),
        Text(
          'Treatment Options',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        ...info.treatments.map(
          (treatment) => _buildListItem(
            context,
            treatment,
            Icons.medical_services_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildSelfCareSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.paddingXLarge),
        Text(
          'Self-Care Strategies',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        ...info.selfCareStrategies.map(
          (strategy) =>
              _buildListItem(context, strategy, Icons.self_improvement),
        ),
      ],
    );
  }

  Widget _buildWarningSignsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.paddingXLarge),
        Text(
          'When to Seek Professional Help',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppConstants.errorColor,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: AppConstants.errorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(
              color: AppConstants.errorColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children:
                info.warningSignsToSeekHelp
                    .map(
                      (sign) => _buildListItem(
                        context,
                        sign,
                        Icons.warning_outlined,
                        color: AppConstants.errorColor,
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildResourcesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.paddingXLarge),
        Text(
          'Additional Resources',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        ...info.resources.map(
          (resource) => _buildListItem(context, resource, Icons.link),
        ),
      ],
    );
  }

  Widget _buildListItem(
    BuildContext context,
    String text,
    IconData icon, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: color ?? _getCategoryColor(info.category),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 20),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Important Disclaimer',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'This information is for educational purposes only and is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of qualified health providers with any questions you may have regarding a medical condition.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppConstants.textSecondary),
          ),
        ],
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
        return const Color(0xFF9C27B0);
      case MentalHealthCategory.depression:
        return const Color(0xFF3F51B5);
      case MentalHealthCategory.bipolar:
        return const Color(0xFFFF9800);
      case MentalHealthCategory.ptsd:
        return const Color(0xFF795548);
      case MentalHealthCategory.ocd:
        return const Color(0xFF00BCD4);
      case MentalHealthCategory.adhd:
        return const Color(0xFFFFEB3B);
      case MentalHealthCategory.eatingDisorders:
        return const Color(0xFFE91E63);
      case MentalHealthCategory.substanceAbuse:
        return const Color(0xFF607D8B);
      case MentalHealthCategory.personalityDisorders:
        return const Color(0xFF673AB7);
      case MentalHealthCategory.schizophrenia:
        return const Color(0xFF424242);
      case MentalHealthCategory.generalWellness:
        return const Color(0xFF4CAF50);
    }
  }

  void _shareInfo(BuildContext context) {
    final shareText = '''
${info.title}

${info.description}

${info.content}

For more mental health resources, visit the Mend app.
''';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Information copied to clipboard'),
        backgroundColor: AppConstants.successColor,
      ),
    );
  }
}
