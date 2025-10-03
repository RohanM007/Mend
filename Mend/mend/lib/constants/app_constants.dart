import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'MEND';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Mental Empowerment Nurturing Development - Your personal mental wellness companion';

  // Colors - Blue, Green, Purple Theme
  static const Color primaryColor = Color(0xFF4A90E2); // Calming Blue
  static const Color secondaryColor = Color(0xFF7B68EE); // Soft Purple
  static const Color accentColor = Color(0xFF50C878); // Emerald Green
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF81C784);
  static const Color warningColor = Color(0xFFFFB74D);

  // Dark theme colors
  static const Color darkBackgroundColor = Color(0xFF0D1117);
  static const Color darkSurfaceColor = Color(0xFF161B22);
  static const Color darkCardColor = Color(0xFF21262D);
  static const Color darkPrimaryColor = Color(
    0xFF6BA3F5,
  ); // Lighter blue for dark mode
  static const Color darkSecondaryColor = Color(
    0xFF9B8CE8,
  ); // Lighter purple for dark mode
  static const Color darkAccentColor = Color(
    0xFF7DD87A,
  ); // Lighter green for dark mode

  // Text colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFFBDC3C7);
  
  //dark theme text which is more contrast friendly 
  static const Color darkTextPrimary   = Color(0xFFEFEFEF); // Main body text
  static const Color darkTextSecondary = Color(0xFFB0B8C4); // Hints, captions
  static const Color darkTextDisabled  = Color(0xFF6B7280); // Disabled, subtle
  

  // Additional theme colors
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color lightGreen = Color(0xFFE8F5E8);
  static const Color lightPurple = Color(0xFFF3E5F5);
  static const Color gradientStart = Color(0xFF4A90E2);
  static const Color gradientEnd = Color(0xFF7B68EE);

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Meditation categories
  static const List<String> meditationCategories = [
    'Stress Relief',
    'Sleep',
    'Anxiety',
    'Grounding',
    'Self-Compassion',
    'Mindfulness',
    'Breathing',
    'Body Scan',
  ];

  // Mental health topics
  static const List<String> mentalHealthTopics = [
    'Anxiety',
    'Depression',
    'Burnout',
    'Trauma',
    'Overthinking',
    'Self-Care',
    'Boundaries',
    'Stress Management',
    'Sleep Hygiene',
    'Mindfulness',
  ];

  // Daily affirmations
  static const List<String> dailyAffirmations = [
    "You are allowed to rest.",
    "Even broken things can still bloom.",
    "God has not forgotten you.",
    "Your feelings are valid and important.",
    "You are stronger than you think.",
    "It's okay to not be okay sometimes.",
    "You deserve love and kindness.",
    "Every small step forward matters.",
    "You are enough, just as you are.",
    "Tomorrow is a new opportunity.",
    "Your mental health matters.",
    "You have survived difficult days before.",
    "It's okay to ask for help.",
    "You are worthy of peace and happiness.",
    "Your journey is unique and valuable.",
    "You are loved more than you know.",
    "Healing is not linear, and that's okay.",
    "You have the strength to overcome this.",
    "Your story matters.",
    "You are not alone in this journey.",
    "Progress, not perfection.",
    "You are capable of amazing things.",
    "Your heart is brave and resilient.",
    "You deserve compassion, especially from yourself.",
    "Every breath is a new beginning.",
    "You are a work of art in progress.",
    "Your sensitivity is a superpower.",
    "You have permission to prioritize yourself.",
    "You are worthy of all good things.",
    "Your presence makes a difference.",
  ];

  // Shared preferences keys
  static const String keyDarkMode = 'dark_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyDailyReminderTime = 'daily_reminder_time';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyLastAffirmationDate = 'last_affirmation_date';

  // Firestore collection names
  static const String usersCollection = 'users';
  static const String moodsCollection = 'moods';
  static const String journalCollection = 'journal';
  static const String affirmationsCollection = 'affirmations';

  // Error messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Please check your internet connection.';
  static const String errorAuth = 'Authentication failed. Please try again.';
  static const String errorPermission = 'Permission denied.';

  // Success messages
  static const String successSaved = 'Saved successfully!';
  static const String successDeleted = 'Deleted successfully!';
  static const String successUpdated = 'Updated successfully!';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxJournalTitleLength = 100;
  static const int maxJournalContentLength = 10000;
  static const int maxMoodNoteLength = 500;

  // Chart colors for mood tracking
  static const List<Color> chartColors = [
    Color(0xFF4CAF50), // Green
    Color(0xFF8BC34A), // Light Green
    Color(0xFFFFC107), // Amber
    Color(0xFFFF9800), // Orange
    Color(0xFFF44336), // Red
    Color(0xFF9C27B0), // Purple
    Color(0xFFE91E63), // Pink
    Color(0xFF00BCD4), // Cyan
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF795548), // Brown
  ];

  // Additional SharedPreferences keys
  static const String keyThemeMode = 'theme_mode';
}
