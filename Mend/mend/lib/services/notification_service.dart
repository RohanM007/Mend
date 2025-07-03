import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // Notification IDs for different types
  static const int _dailyTipBaseId = 1000;
  static const int _moodReminderBaseId = 2000;
  static const int _journalPromptBaseId = 3000;
  static const int _meditationReminderBaseId = 4000;

  // Daily Wellness Tips Content
  static const List<String> _dailyWellnessTips = [
    "Take 5 deep breaths and notice how your body feels",
    "Practice the 5-4-3-2-1 grounding technique: 5 things you see, 4 you hear, 3 you touch, 2 you smell, 1 you taste",
    "Write down 3 things you're grateful for today",
    "Step outside for 10 minutes of natural sunlight",
    "Call or text someone you care about",
    "Do a 2-minute body scan meditation",
    "Drink a glass of water mindfully, focusing on the taste and temperature",
    "Practice saying 'no' to protect your energy and mental health",
    "Take a 5-minute walk, even if it's just around your home",
    "Listen to your favorite song and really focus on the lyrics",
    "Stretch your body for 3 minutes to release tension",
    "Practice self-compassion - speak to yourself like you would a good friend",
    "Declutter one small area of your space",
    "Try the 4-7-8 breathing technique: inhale for 4, hold for 7, exhale for 8",
    "Write down one thing you accomplished today, no matter how small",
    "Practice progressive muscle relaxation for 5 minutes",
    "Look at photos that make you happy",
    "Do something creative for 10 minutes - draw, write, or craft",
    "Practice mindful eating with your next meal",
    "Send yourself a kind message or affirmation",
    "Take a warm shower or bath and focus on the sensations",
    "Practice the 'STOP' technique: Stop, Take a breath, Observe, Proceed mindfully",
    "Spend 5 minutes in nature, even if it's just looking out a window",
    "Do a random act of kindness for someone",
    "Practice visualization - imagine your ideal peaceful place",
    "Try the 'Three Good Things' exercise before bed",
    "Practice mindful listening - really focus when someone is speaking",
    "Do gentle yoga stretches for 5 minutes",
    "Practice loving-kindness meditation for yourself and others",
    "Take a digital break for 30 minutes",
    "Practice the 'RAIN' technique: Recognize, Allow, Investigate, Non-attachment",
    "Write a letter to your future self",
    "Practice mindful walking - focus on each step",
    "Do something that makes you laugh",
    "Practice the 'Box Breathing' technique: 4 counts in, hold 4, out 4, hold 4",
    "Organize your thoughts by writing them down",
    "Practice acceptance of something you cannot change",
    "Do a 5-minute meditation using a guided app",
    "Practice gratitude by thanking someone who helped you",
    "Take time to appreciate something beautiful around you",
    "Practice self-care by doing something just for you",
    "Try the 'Worry Time' technique - set aside 15 minutes to worry, then let it go",
    "Practice mindful breathing during a routine activity",
    "Connect with your values - what matters most to you?",
    "Practice the 'One Thing' rule - focus on just one task at a time",
    "Do something that brings you joy, even if it's small",
    "Practice emotional awareness - name what you're feeling",
    "Take a moment to appreciate your body and what it does for you",
    "Practice the 'Pause and Reset' technique when feeling overwhelmed",
    "End your day by reflecting on one positive moment",
  ];

  // Mood Check-in Reminders
  static const List<String> _moodReminders = [
    "How are you feeling right now? Take a moment to check in with yourself",
    "What's your emotional weather like today?",
    "Time for a mood check - how would you rate your feelings?",
    "Take a pause and notice your current emotional state",
    "How has your mood been today? Log it in your wellness journal",
    "Check in with yourself - what emotions are you experiencing?",
    "Rate your mood and see how you're tracking over time",
    "What's your energy level like right now?",
    "How are you feeling emotionally, physically, and mentally?",
    "Take a moment to acknowledge your feelings without judgment",
  ];

  // Journal Prompts
  static const List<String> _journalPrompts = [
    "What made you smile today?",
    "Describe a challenge you overcame recently",
    "What are you looking forward to?",
    "Write about someone who inspires you",
    "What's one thing you learned about yourself this week?",
    "Describe your ideal day",
    "What are you most grateful for right now?",
    "Write about a moment when you felt truly peaceful",
    "What's something you'd like to forgive yourself for?",
    "Describe a goal you're working toward",
    "What's bringing you joy lately?",
    "Write about a time you showed courage",
    "What would you tell your younger self?",
    "Describe your perfect evening routine",
    "What's one way you've grown this month?",
  ];

  // Meditation Reminders
  static const List<String> _meditationReminders = [
    "Time for mindfulness - try a 5-minute meditation",
    "Take a moment to center yourself with deep breathing",
    "Your mind deserves a peaceful break - meditate for a few minutes",
    "Practice mindfulness and be present in this moment",
    "Give yourself the gift of 5 minutes of stillness",
    "Time to reconnect with your breath and inner calm",
    "Your meditation practice is calling - even 3 minutes helps",
    "Take a mindful moment to reset and recharge",
    "Practice loving-kindness meditation for yourself and others",
    "Find your center with a brief mindfulness session",
  ];

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize timezone data
      tz.initializeTimeZones();

      // Android initialization settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _initialized = true;
    } catch (e) {
      debugPrint('Failed to initialize notifications: $e');
      // Don't throw - allow app to continue without notifications
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - could navigate to specific screens
    // This will be called when user taps on a notification
    debugPrint('Notification tapped: ${response.payload}');
  }

  static Future<bool> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      final bool? granted =
          await androidImplementation.requestNotificationsPermission();
      return granted ?? false;
    }

    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

    if (iosImplementation != null) {
      final bool? granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true; // Default to true for other platforms
  }

  static Future<void> scheduleAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    // Get user settings
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    final dailyTips = prefs.getBool('daily_wellness_tips') ?? true;
    final moodReminders = prefs.getBool('mood_reminders') ?? true;
    final journalReminders = prefs.getBool('journal_reminders') ?? false;
    final meditationReminders = prefs.getBool('meditation_reminders') ?? true;
    final reminderTimeString = prefs.getString('reminder_time') ?? '9:00 AM';

    if (!notificationsEnabled) return;

    // Cancel existing notifications
    await cancelAllNotifications();

    // Parse reminder time
    final reminderTime = _parseTime(reminderTimeString);

    // Schedule different types of notifications
    if (dailyTips) {
      await _scheduleDailyWellnessTips(reminderTime);
    }

    if (moodReminders) {
      await _scheduleMoodReminders(_addHoursToTime(reminderTime, 3));
    }

    if (journalReminders) {
      await _scheduleJournalPrompts(_addHoursToTime(reminderTime, 6));
    }

    if (meditationReminders) {
      await _scheduleMeditationReminders(_addHoursToTime(reminderTime, 9));
    }

    // Save last refresh date
    await prefs.setString(
      'last_notification_refresh',
      DateTime.now().toIso8601String(),
    );
  }

  static TimeOfDay _parseTime(String timeString) {
    // Parse time string like "9:00 AM" or "21:00"
    final parts = timeString
        .replaceAll(' AM', '')
        .replaceAll(' PM', '')
        .split(':');
    int hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    if (timeString.contains('PM') && hour != 12) {
      hour += 12;
    } else if (timeString.contains('AM') && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  static TimeOfDay _addHoursToTime(TimeOfDay time, int hours) {
    final totalMinutes = time.hour * 60 + time.minute + (hours * 60);
    final newHour = (totalMinutes ~/ 60) % 24;
    final newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  static Future<void> _scheduleDailyWellnessTips(TimeOfDay time) async {
    for (int i = 0; i < 30; i++) {
      final scheduledDate = _getNextScheduledDate(time).add(Duration(days: i));
      final tipIndex = i % _dailyWellnessTips.length;

      await _notifications.zonedSchedule(
        _dailyTipBaseId + i,
        '💡 Daily Wellness Tip',
        _dailyWellnessTips[tipIndex],
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_tips',
            'Daily Wellness Tips',
            channelDescription: 'Daily mental health and wellness tips',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(categoryIdentifier: 'daily_tips'),
        ),
        payload: 'daily_tip',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static Future<void> _scheduleMoodReminders(TimeOfDay time) async {
    for (int i = 0; i < 30; i++) {
      final scheduledDate = _getNextScheduledDate(time).add(Duration(days: i));
      final reminderIndex = i % _moodReminders.length;

      await _notifications.zonedSchedule(
        _moodReminderBaseId + i,
        '🌟 Mood Check-in',
        _moodReminders[reminderIndex],
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'mood_reminders',
            'Mood Check-in Reminders',
            channelDescription: 'Reminders to log your mood',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(categoryIdentifier: 'mood_reminders'),
        ),
        payload: 'mood_reminder',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static Future<void> _scheduleJournalPrompts(TimeOfDay time) async {
    for (int i = 0; i < 30; i++) {
      final scheduledDate = _getNextScheduledDate(time).add(Duration(days: i));
      final promptIndex = i % _journalPrompts.length;

      await _notifications.zonedSchedule(
        _journalPromptBaseId + i,
        '✍️ Journal Prompt',
        _journalPrompts[promptIndex],
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'journal_prompts',
            'Journal Prompts',
            channelDescription: 'Writing prompts and reminders',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(categoryIdentifier: 'journal_prompts'),
        ),
        payload: 'journal_prompt',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static Future<void> _scheduleMeditationReminders(TimeOfDay time) async {
    for (int i = 0; i < 30; i++) {
      final scheduledDate = _getNextScheduledDate(time).add(Duration(days: i));
      final reminderIndex = i % _meditationReminders.length;

      await _notifications.zonedSchedule(
        _meditationReminderBaseId + i,
        '🧘 Meditation Time',
        _meditationReminders[reminderIndex],
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'meditation_reminders',
            'Meditation Reminders',
            channelDescription: 'Time for mindfulness and meditation',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: 'meditation_reminders',
          ),
        ),
        payload: 'meditation_reminder',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static DateTime _getNextScheduledDate(TimeOfDay time) {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> cancelNotificationType(String type) async {
    switch (type) {
      case 'daily_tips':
        for (int i = 0; i < 30; i++) {
          await _notifications.cancel(_dailyTipBaseId + i);
        }
        break;
      case 'mood_reminders':
        for (int i = 0; i < 30; i++) {
          await _notifications.cancel(_moodReminderBaseId + i);
        }
        break;
      case 'journal_prompts':
        for (int i = 0; i < 30; i++) {
          await _notifications.cancel(_journalPromptBaseId + i);
        }
        break;
      case 'meditation_reminders':
        for (int i = 0; i < 30; i++) {
          await _notifications.cancel(_meditationReminderBaseId + i);
        }
        break;
    }
  }

  static Future<bool> shouldRefreshNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastRefreshString = prefs.getString('last_notification_refresh');

      if (lastRefreshString == null) return true;

      final lastRefresh = DateTime.parse(lastRefreshString);
      final daysSinceRefresh = DateTime.now().difference(lastRefresh).inDays;

      return daysSinceRefresh >= 14; // Refresh every 2 weeks
    } catch (e) {
      debugPrint('Error checking notification refresh: $e');
      return false; // Don't refresh if there's an error
    }
  }

  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  static Future<void> showTestNotification() async {
    await _notifications.show(
      0,
      '🎉 Test Notification',
      'Your notifications are working perfectly!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test',
          'Test Notifications',
          channelDescription: 'Test notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
