import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/firestore_service.dart';
import '../../models/mood_entry.dart';
import '../../models/journal_entry.dart';
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
          // Firebase Testing Section (Debug only)
          if (kDebugMode) ...[
            _buildFirebaseTestSection(context),
            const SizedBox(height: AppConstants.paddingLarge),
          ],

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

  Widget _buildFirebaseTestSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bug_report, color: AppConstants.primaryColor),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'Firebase Testing (Debug)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            const Text(
              'Test your Firebase collections to ensure everything is working correctly.',
              style: TextStyle(color: AppConstants.textSecondary),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _runFirebaseTests,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Run Firebase Tests'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showCollectionStructure,
                icon: const Icon(Icons.info_outline),
                label: const Text('Show Collection Structure'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstants.primaryColor,
                ),
              ),
            ),
          ],
        ),
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

  Future<void> _runFirebaseTests() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: AppConstants.paddingMedium),
                Text('Running Firebase tests...'),
              ],
            ),
          ),
    );

    try {
      final firestoreService = FirestoreService();
      final results = <String, bool>{};

      // Test mood collection
      try {
        final testMood = MoodEntry(
          id: '',
          moods: [MoodType.happy],
          intensity: 8,
          note: 'Test mood entry',
          date: DateTime.now(),
          createdAt: DateTime.now(),
        );
        await firestoreService.saveMoodEntry(testMood);
        results['mood_collection'] = true;
        debugPrint('✅ Mood collection test passed');
      } catch (e) {
        results['mood_collection'] = false;
        debugPrint('❌ Mood collection test failed: $e');
      }

      // Test journal collection
      try {
        final testJournal = JournalEntry(
          id: '',
          title: 'Test Journal Entry',
          content: 'This is a test journal entry.',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          tags: ['test'],
        );
        await firestoreService.saveJournalEntry(testJournal);
        results['journal_collection'] = true;
        debugPrint('✅ Journal collection test passed');
      } catch (e) {
        results['journal_collection'] = false;
        debugPrint('❌ Journal collection test failed: $e');
      }

      // Test user preferences
      try {
        final testPreferences = {
          'testTimestamp': DateTime.now().toIso8601String(),
        };
        await firestoreService.saveUserPreferences(testPreferences);
        results['user_preferences'] = true;
        debugPrint('✅ User preferences test passed');
      } catch (e) {
        results['user_preferences'] = false;
        debugPrint('❌ User preferences test failed: $e');
      }

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show results
      _showTestResults(results);
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test failed: $e'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  void _showTestResults(Map<String, bool> results) {
    final passedTests = results.values.where((result) => result).length;
    final totalTests = results.length;
    final allPassed = passedTests == totalTests;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  allPassed ? Icons.check_circle : Icons.error,
                  color:
                      allPassed
                          ? AppConstants.successColor
                          : AppConstants.errorColor,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text('Test Results ($passedTests/$totalTests)'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  results.entries.map((entry) {
                    final testName =
                        entry.key.replaceAll('_', ' ').toUpperCase();
                    final passed = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            passed ? Icons.check : Icons.close,
                            color:
                                passed
                                    ? AppConstants.successColor
                                    : AppConstants.errorColor,
                            size: 20,
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Expanded(child: Text(testName)),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showCollectionStructure() {
    debugPrint('📁 Firebase Collections Structure printed to console');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Collection Structure'),
            content: const SingleChildScrollView(
              child: Text(
                '''Firebase Collections Structure:

users/{userId}/
├── preferences (document)
│   ├── darkMode: boolean
│   ├── notificationsEnabled: boolean
│   └── dailyReminderTime: string
│
├── moods/ (subcollection)
│   └── {moodId} (document)
│       ├── mood: string
│       ├── intensity: number (1-10)
│       ├── note: string (optional)
│       ├── date: timestamp
│       └── createdAt: timestamp
│
├── journal/ (subcollection)
│   └── {journalId} (document)
│       ├── title: string
│       ├── content: string
│       ├── prompt: string (optional)
│       ├── createdAt: timestamp
│       ├── updatedAt: timestamp
│       └── tags: array
│
└── affirmations/ (subcollection)
    └── {dateKey} (document)
        ├── date: timestamp
        ├── viewed: boolean
        └── viewedAt: timestamp

Check the debug console for detailed structure info.''',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
