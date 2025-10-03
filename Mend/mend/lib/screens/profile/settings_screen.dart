import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../constants/app_constants.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
         
          const SizedBox(height: AppConstants.paddingLarge),

          // Data Section
          _buildDataSection(context),

          const SizedBox(height: AppConstants.paddingLarge),

          // About Section
          _buildAboutSection(context),
        ],
      ),
    );
  }



  Widget _buildDataSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Management',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            ListTile(
              title: const Text('Clear Cache'),
              subtitle: const Text('Free up storage space'),
              leading: const Icon(
                Icons.cleaning_services,
                color: AppConstants.primaryColor,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showClearCacheDialog(context),
            ),
            ListTile(
              title: const Text('Delete Account'),
              subtitle: const Text('Permanently delete your account'),
              leading: const Icon(
                Icons.delete_forever,
                color: AppConstants.errorColor,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showDeleteAccountDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            ListTile(
              title: const Text('App Version'),
              subtitle: Text(AppConstants.appVersion),
              leading: const Icon(Icons.info, color: AppConstants.primaryColor),
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              subtitle: const Text('How we protect your privacy'),
              leading: const Icon(
                Icons.policy,
                color: AppConstants.primaryColor,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cache'),
            content: const Text(
              'This will clear temporary files and free up storage space. Your data will not be affected.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cache cleared successfully'),
                      backgroundColor: AppConstants.successColor,
                    ),
                  );
                },
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
              'This action cannot be undone. All your data will be permanently deleted.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppConstants.errorColor,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
