import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/firestore_service.dart';

class MoodProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<MoodEntry> _moodEntries = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MoodEntry> get moodEntries => _moodEntries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get entries for different time periods
  List<MoodEntry> get weeklyEntries {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return _moodEntries.where((entry) => entry.date.isAfter(weekAgo)).toList();
  }

  List<MoodEntry> get monthlyEntries {
    final now = DateTime.now();
    final monthAgo = DateTime(now.year, now.month - 1, now.day);
    return _moodEntries.where((entry) => entry.date.isAfter(monthAgo)).toList();
  }

  MoodProvider() {
    _loadMoodEntries();
  }

  Future<void> _loadMoodEntries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _firestoreService.getMoodEntries().listen((entries) {
        _moodEntries = entries;
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveMoodEntry(MoodEntry entry) async {
    try {
      await _firestoreService.saveMoodEntry(entry);
      // The stream will automatically update _moodEntries
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  bool hasLoggedToday() {
    final today = DateTime.now();
    return _moodEntries.any((entry) =>
        entry.date.year == today.year &&
        entry.date.month == today.month &&
        entry.date.day == today.day);
  }

  MoodEntry? getTodaysMood() {
    final today = DateTime.now();
    try {
      return _moodEntries.firstWhere((entry) =>
          entry.date.year == today.year &&
          entry.date.month == today.month &&
          entry.date.day == today.day);
    } catch (e) {
      return null;
    }
  }

  Future<List<MoodEntry>> getMoodEntriesForDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      return await _firestoreService.getMoodEntriesForDateRange(startDate, endDate);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }

  Map<MoodType, double> getMoodSummary() {
    if (_moodEntries.isEmpty) return {};

    final moodCounts = <MoodType, int>{};
    for (final entry in _moodEntries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }

    final total = _moodEntries.length;
    return moodCounts.map((mood, count) => MapEntry(mood, count / total));
  }

  double getAverageIntensity() {
    if (_moodEntries.isEmpty) return 0;
    
    final totalIntensity = _moodEntries.fold<int>(
      0, (sum, entry) => sum + entry.intensity);
    return totalIntensity / _moodEntries.length;
  }

  List<MoodEntry> getMoodsByType(MoodType moodType) {
    return _moodEntries.where((entry) => entry.mood == moodType).toList();
  }

  // Get mood trends (improving, declining, stable)
  MoodTrend getMoodTrend() {
    if (_moodEntries.length < 2) return MoodTrend.stable;

    final recentEntries = _moodEntries.take(7).toList();
    if (recentEntries.length < 2) return MoodTrend.stable;

    final recentAverage = recentEntries.fold<int>(
      0, (sum, entry) => sum + entry.intensity) / recentEntries.length;

    final olderEntries = _moodEntries.skip(7).take(7).toList();
    if (olderEntries.isEmpty) return MoodTrend.stable;

    final olderAverage = olderEntries.fold<int>(
      0, (sum, entry) => sum + entry.intensity) / olderEntries.length;

    const threshold = 0.5;
    if (recentAverage > olderAverage + threshold) {
      return MoodTrend.improving;
    } else if (recentAverage < olderAverage - threshold) {
      return MoodTrend.declining;
    } else {
      return MoodTrend.stable;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadMoodEntries();
  }
}

enum MoodTrend {
  improving,
  declining,
  stable,
}

extension MoodTrendExtension on MoodTrend {
  String get displayName {
    switch (this) {
      case MoodTrend.improving:
        return 'Improving';
      case MoodTrend.declining:
        return 'Needs Attention';
      case MoodTrend.stable:
        return 'Stable';
    }
  }

  IconData get icon {
    switch (this) {
      case MoodTrend.improving:
        return Icons.trending_up;
      case MoodTrend.declining:
        return Icons.trending_down;
      case MoodTrend.stable:
        return Icons.trending_flat;
    }
  }

  Color get color {
    switch (this) {
      case MoodTrend.improving:
        return const Color(0xFF4CAF50);
      case MoodTrend.declining:
        return const Color(0xFFF44336);
      case MoodTrend.stable:
        return const Color(0xFFFFC107);
    }
  }
}
