import 'package:flutter/material.dart';
import '../models/meditation.dart';
import '../services/meditation_service.dart';

class MeditationProvider with ChangeNotifier {
  final MeditationService _meditationService = MeditationService();
  
  List<Meditation> _meditations = [];
  List<MeditationSession> _sessions = [];
  bool _isLoading = false;
  String? _errorMessage;
  MeditationSession? _currentSession;

  List<Meditation> get meditations => _meditations;
  List<MeditationSession> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  MeditationSession? get currentSession => _currentSession;

  MeditationProvider() {
    _loadMeditations();
    _loadSessions();
  }

  Future<void> _loadMeditations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _meditations = await _meditationService.getMeditations();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSessions() async {
    try {
      _meditationService.getMeditationSessions().listen((sessions) {
        _sessions = sessions;
        notifyListeners();
      });
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<MeditationSession> startMeditationSession(Meditation meditation) async {
    try {
      final session = await _meditationService.startMeditationSession(meditation);
      _currentSession = session;
      notifyListeners();
      return session;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> completeMeditationSession(
    MeditationSession session, {
    double? rating,
    String? notes,
  }) async {
    try {
      await _meditationService.completeMeditationSession(
        session,
        rating: rating,
        notes: notes,
      );
      _currentSession = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> cancelMeditationSession(MeditationSession session) async {
    try {
      await _meditationService.cancelMeditationSession(session);
      _currentSession = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Get meditation statistics
  int getMeditationStreak() {
    if (_sessions.isEmpty) return 0;

    final completedSessions = _sessions.where((s) => s.completed).toList();
    if (completedSessions.isEmpty) return 0;

    completedSessions.sort((a, b) => b.startTime.compareTo(a.startTime));

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    int streak = 0;
    DateTime checkDate = todayDate;

    while (true) {
      final hasSessionForDate = completedSessions.any((session) {
        final sessionDate = DateTime(
          session.startTime.year,
          session.startTime.month,
          session.startTime.day,
        );
        return sessionDate == checkDate;
      });

      if (hasSessionForDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        // If it's today and no session, don't break the streak yet
        if (checkDate == todayDate) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }
    }

    return streak;
  }

  int getTotalSessions() {
    return _sessions.where((s) => s.completed).length;
  }

  int getTotalMinutes() {
    return _sessions
        .where((s) => s.completed)
        .fold(0, (sum, session) => sum + session.durationMinutes);
  }

  List<MeditationSession> getRecentSessions({int limit = 10}) {
    final completedSessions = _sessions.where((s) => s.completed).toList();
    completedSessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return completedSessions.take(limit).toList();
  }

  List<Meditation> getMeditationsByCategory(String category) {
    return _meditations.where((m) => m.category == category).toList();
  }

  List<Meditation> getFavoriteMeditations() {
    // Get meditations that have been completed multiple times
    final meditationCounts = <String, int>{};
    for (final session in _sessions.where((s) => s.completed)) {
      meditationCounts[session.meditationId] = 
          (meditationCounts[session.meditationId] ?? 0) + 1;
    }

    final favoriteIds = meditationCounts.entries
        .where((entry) => entry.value >= 3)
        .map((entry) => entry.key)
        .toList();

    return _meditations.where((m) => favoriteIds.contains(m.id)).toList();
  }

  List<Meditation> getRecommendedMeditations() {
    // Simple recommendation based on recent activity
    final recentSessions = getRecentSessions(limit: 5);
    final recentCategories = recentSessions
        .map((s) => _meditations.firstWhere((m) => m.id == s.meditationId).category)
        .toSet()
        .toList();

    if (recentCategories.isEmpty) {
      // Return beginner-friendly meditations
      return _meditations.where((m) => m.difficulty <= 2).take(5).toList();
    }

    return _meditations
        .where((m) => recentCategories.contains(m.category))
        .take(5)
        .toList();
  }

  double getAverageRating() {
    final ratedSessions = _sessions.where((s) => s.rating != null).toList();
    if (ratedSessions.isEmpty) return 0.0;

    final totalRating = ratedSessions.fold<double>(
      0.0, (sum, session) => sum + session.rating!);
    return totalRating / ratedSessions.length;
  }

  Map<String, int> getCategoryStats() {
    final categoryStats = <String, int>{};
    for (final session in _sessions.where((s) => s.completed)) {
      final meditation = _meditations.firstWhere((m) => m.id == session.meditationId);
      categoryStats[meditation.category] = 
          (categoryStats[meditation.category] ?? 0) + 1;
    }
    return categoryStats;
  }

  List<MeditationSession> getSessionsForDateRange(DateTime start, DateTime end) {
    return _sessions.where((session) {
      return session.startTime.isAfter(start) && session.startTime.isBefore(end);
    }).toList();
  }

  bool hasMeditatedToday() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    return _sessions.any((session) {
      final sessionDate = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );
      return sessionDate == todayDate && session.completed;
    });
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadMeditations();
  }
}
