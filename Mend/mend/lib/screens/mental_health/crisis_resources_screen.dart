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
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.errorColor.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency banner
              _buildEmergencyBanner(context),

              const SizedBox(height: AppConstants.paddingXLarge),

              // Crisis hotlines
              _buildCrisisHotlines(context),

              const SizedBox(height: AppConstants.paddingXLarge),

              // Professional help
              _buildProfessionalHelp(context),

              const SizedBox(height: AppConstants.paddingXLarge),

              // Safety planning
              _buildSafetyPlanning(context),

              const SizedBox(height: AppConstants.paddingLarge),

              // Bottom disclaimer
              _buildBottomDisclaimer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.errorColor,
            AppConstants.errorColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppConstants.errorColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emergency, color: Colors.white, size: 48),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'Emergency Assistance',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'If you are in immediate danger or having thoughts of self-harm',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'Call emergency services or go to your nearest emergency room',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall('10111'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppConstants.errorColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMedium,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.phone, size: 20),
                  label: const Text(
                    'Call 10111',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisHotlines(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          '24/7 Crisis Support',
          Icons.support_agent,
          'Professional help available anytime',
        ),
        const SizedBox(height: AppConstants.paddingLarge),
        ...CrisisResource.defaultCrisisResources.map(
          (resource) => _buildCrisisResourceCard(context, resource),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: AppConstants.primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisResourceCard(
    BuildContext context,
    CrisisResource resource,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppConstants.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.support_agent,
                    color: AppConstants.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Text(
                    resource.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryColor,
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
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              resource.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _makePhoneCall(resource.phoneNumber),
                    icon: const Icon(Icons.phone, size: 18),
                    label: Text(
                      resource.phoneNumber,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMedium,
                        ),
                      ),
                      elevation: 2,
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
        _buildSectionHeader(
          context,
          'Finding Professional Help',
          Icons.psychology,
          'Connect with qualified mental health professionals',
        ),
        const SizedBox(height: AppConstants.paddingLarge),
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
        _buildSectionHeader(
          context,
          'Safety Planning',
          Icons.security,
          'Create a plan to stay safe during difficult times',
        ),
        const SizedBox(height: AppConstants.paddingLarge),
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

  Widget _buildBottomDisclaimer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppConstants.warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: AppConstants.warningColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppConstants.warningColor,
                size: 24,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Important Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.warningColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'These resources are provided for informational purposes. If you are experiencing a mental health emergency, please contact emergency services immediately.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'This app is not a substitute for professional medical advice, diagnosis, or treatment.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
