import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry.dart';
import '../services/firestore_service.dart';

class JournalProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<JournalEntry> _journalEntries = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<List<JournalEntry>>? _journalEntriesSubscription;
  String? _currentUserId;

  List<JournalEntry> get journalEntries => _journalEntries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  JournalProvider() {
    // Don't load data immediately - wait for user authentication
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      final newUserId = user?.uid;

      if (newUserId != _currentUserId) {
        // User changed - clear old data and load new data
        _clearData();
        _currentUserId = newUserId;

        if (newUserId != null) {
          _loadJournalEntries();
        }
      }
    });
  }

  void _clearData() {
    _journalEntriesSubscription?.cancel();
    _journalEntriesSubscription = null;
    _journalEntries.clear();
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _loadJournalEntries() async {
    if (_currentUserId == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _journalEntriesSubscription = _firestoreService
          .getJournalEntries()
          .listen(
            (entries) {
              _journalEntries = entries;
              _isLoading = false;
              notifyListeners();
            },
            onError: (error) {
              _errorMessage = error.toString();
              _isLoading = false;
              notifyListeners();
            },
          );
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveJournalEntry(JournalEntry entry) async {
    try {
      await _firestoreService.saveJournalEntry(entry);
      // The stream will automatically update _journalEntries
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteJournalEntry(String entryId) async {
    try {
      await _firestoreService.deleteJournalEntry(entryId);
      // The stream will automatically update _journalEntries
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  List<JournalEntry> getEntriesByTag(String tag) {
    return _journalEntries.where((entry) => entry.tags.contains(tag)).toList();
  }

  List<JournalEntry> getEntriesForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _journalEntries.where((entry) {
      return entry.createdAt.isAfter(startDate) &&
          entry.createdAt.isBefore(endDate);
    }).toList();
  }

  List<String> getAllTags() {
    final allTags = <String>{};
    for (final entry in _journalEntries) {
      allTags.addAll(entry.tags);
    }
    return allTags.toList()..sort();
  }

  Map<String, int> getTagFrequency() {
    final tagFreq = <String, int>{};
    for (final entry in _journalEntries) {
      for (final tag in entry.tags) {
        tagFreq[tag] = (tagFreq[tag] ?? 0) + 1;
      }
    }
    return tagFreq;
  }

  int getTotalWordCount() {
    return _journalEntries.fold(0, (sum, entry) => sum + entry.wordCount);
  }

  int getTotalEntries() {
    return _journalEntries.length;
  }

  JournalEntry? getLatestEntry() {
    if (_journalEntries.isEmpty) return null;
    return _journalEntries.first; // Assuming entries are sorted by date desc
  }

  List<JournalEntry> getRecentEntries({int limit = 5}) {
    return _journalEntries.take(limit).toList();
  }

  // Get writing streak (consecutive days with entries)
  int getWritingStreak() {
    if (_journalEntries.isEmpty) return 0;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    int streak = 0;
    DateTime checkDate = todayDate;

    while (true) {
      final hasEntryForDate = _journalEntries.any((entry) {
        final entryDate = DateTime(
          entry.createdAt.year,
          entry.createdAt.month,
          entry.createdAt.day,
        );
        return entryDate == checkDate;
      });

      if (hasEntryForDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        // If it's today and no entry, don't break the streak yet
        if (checkDate == todayDate) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }
    }

    return streak;
  }

  // Get entries for a specific month
  List<JournalEntry> getEntriesForMonth(int year, int month) {
    return _journalEntries.where((entry) {
      return entry.createdAt.year == year && entry.createdAt.month == month;
    }).toList();
  }

  // Search entries
  List<JournalEntry> searchEntries(String query) {
    if (query.isEmpty) return _journalEntries;

    final lowerQuery = query.toLowerCase();
    return _journalEntries.where((entry) {
      return entry.title.toLowerCase().contains(lowerQuery) ||
          entry.content.toLowerCase().contains(lowerQuery) ||
          entry.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Get mood-related entries (if they contain mood keywords)
  List<JournalEntry> getMoodRelatedEntries() {
    const moodKeywords = [
      'happy',
      'sad',
      'angry',
      'excited',
      'anxious',
      'calm',
      'stressed',
      'depressed',
      'joyful',
      'worried',
      'peaceful',
      'frustrated',
      'content',
      'overwhelmed',
      'grateful',
      'hopeful',
      'lonely',
      'confident',
      'scared',
    ];

    return _journalEntries.where((entry) {
      final content = '${entry.title} ${entry.content}'.toLowerCase();
      return moodKeywords.any((keyword) => content.contains(keyword));
    }).toList();
  }

  // Get entries with prompts
  List<JournalEntry> getPromptEntries() {
    return _journalEntries.where((entry) => entry.prompt != null).toList();
  }

  @override
  void dispose() {
    _journalEntriesSubscription?.cancel();
    super.dispose();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadJournalEntries();
  }
}
