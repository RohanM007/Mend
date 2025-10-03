import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/mental_health_info.dart';
import '../../constants/app_constants.dart';

class CrisisResourcesScreen extends StatelessWidget {
  const CrisisResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crisis Resources'),
        backgroundColor: AppConstants.errorColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency banner
            _buildEmergencyBanner(context),

            const SizedBox(height: AppConstants.paddingLarge),

            // Crisis hotlines
            _buildCrisisHotlines(context),

            const SizedBox(height: AppConstants.paddingLarge),

            // Professional help
            _buildProfessionalHelp(context),

            const SizedBox(height: AppConstants.paddingLarge),

            // Safety planning
            _buildSafetyPlanning(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppConstants.errorColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Column(
        children: [
          const Icon(Icons.emergency, color: Colors.white, size: 48),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'If you are in immediate danger',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'Call 10111 or go to your nearest emergency room',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          ElevatedButton(
            onPressed: () => _makePhoneCall('10111'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppConstants.errorColor,
            ),
            child: const Text('Call 10111'),
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisHotlines(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '24/7 Crisis Support',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        ...CrisisResource.defaultCrisisResources.map(
          (resource) => _buildCrisisResourceCard(context, resource),
        ),
      ],
    );
  }

  Widget _buildCrisisResourceCard(
    BuildContext context,
    CrisisResource resource,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    resource.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (resource.isAvailable24_7)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.successColor,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSmall,
                      ),
                    ),
                    child: Text(
                      '24/7',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              resource.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _makePhoneCall(resource.phoneNumber),
                    icon: const Icon(Icons.phone),
                    label: Text(resource.phoneNumber),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                if (resource.website != null) ...[
                  const SizedBox(width: AppConstants.paddingSmall),
                  IconButton(
                    onPressed: () => _launchWebsite(resource.website!),
                    icon: const Icon(Icons.web),
                    tooltip: 'Visit website',
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHelp(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Finding Professional Help',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        ...ProfessionalResource.professionalResources.map(
          (resource) => _buildProfessionalResourceCard(context, resource),
        ),
      ],
    );
  }

  Widget _buildProfessionalResourceCard(
  BuildContext context,
  ProfessionalResource resource,
) {
  return Card(
    margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
    child: Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resource.type,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            resource.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}

  Widget _buildSafetyPlanning(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety Planning',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a safety plan:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                ...[
                  'Identify your warning signs',
                  'List coping strategies that help',
                  'Identify people you can contact',
                  'Remove or secure means of self-harm',
                  'Create a safe environment',
                  'Know who to contact in a crisis',
                ].map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.paddingSmall,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 8, right: 8),
                          decoration: const BoxDecoration(
                            color: AppConstants.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(child: Text(step)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri(scheme: 'tel', path: cleanNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Fallback: copy to clipboard
      Clipboard.setData(ClipboardData(text: phoneNumber));
    }
  }

  void _launchWebsite(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
