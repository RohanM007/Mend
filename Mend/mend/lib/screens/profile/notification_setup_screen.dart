import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/notification_service.dart';

class NotificationSetupScreen extends StatefulWidget {
  const NotificationSetupScreen({super.key});

  @override
  State<NotificationSetupScreen> createState() => _NotificationSetupScreenState();
}

class _NotificationSetupScreenState extends State<NotificationSetupScreen> {
  bool _isLoading = false;
  bool _permissionGranted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Notifications'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Stay on Track with Daily Reminders',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            Text(
              'Get gentle reminders to help you maintain your mental wellness routine.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingXLarge),
            
            // Features list
            _buildFeatureItem(
              '💡 Daily Wellness Tips',
              'Receive personalized mental health tips every day',
            ),
            
            _buildFeatureItem(
              '🌟 Mood Check-ins',
              'Gentle reminders to log your mood and emotions',
            ),
            
            _buildFeatureItem(
              '✍️ Journal Prompts',
              'Creative writing prompts to inspire reflection',
            ),
            
            _buildFeatureItem(
              '🧘 Meditation Reminders',
              'Mindfulness moments to center yourself',
            ),
            
            const SizedBox(height: AppConstants.paddingXLarge),
            
            // Permission status
            if (_permissionGranted)
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppConstants.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: AppConstants.successColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppConstants.successColor,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Expanded(
                      child: Text(
                        'Notifications enabled! You\'ll receive daily wellness reminders.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConstants.successColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            const Spacer(),
            
            // Action buttons
            if (!_permissionGranted) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _requestPermissionAndSetup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Enable Notifications',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isLoading ? null : _skipSetup,
                  child: Text(
                    'Skip for Now',
                    style: TextStyle(
                      color: AppConstants.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _testNotification,
                  child: const Text(
                    'Send Test Notification',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Center(
              child: Text(
                title.split(' ')[0], // Get the emoji
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          
          const SizedBox(width: AppConstants.paddingMedium),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.substring(title.indexOf(' ') + 1), // Remove emoji
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestPermissionAndSetup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Request notification permissions
      final granted = await NotificationService.requestPermissions();
      
      if (granted) {
        // Schedule initial notifications
        await NotificationService.scheduleAllNotifications();
        
        setState(() {
          _permissionGranted = true;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Notifications enabled successfully!'),
              backgroundColor: AppConstants.successColor,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Notification permission denied. You can enable it later in settings.'),
              backgroundColor: AppConstants.warningColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting up notifications: $e'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _skipSetup() {
    Navigator.of(context).pop();
  }

  Future<void> _testNotification() async {
    try {
      await NotificationService.showTestNotification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Test notification sent!'),
            backgroundColor: AppConstants.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending test notification: $e'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }
}
