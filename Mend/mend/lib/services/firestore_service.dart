import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/mood_entry.dart';
import '../models/journal_entry.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // Mood Entries
  Future<void> saveMoodEntry(MoodEntry moodEntry) async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('moods')
          .add(moodEntry.toMap());
    } catch (e) {
      throw Exception('Failed to save mood entry: $e');
    }
  }

  Stream<List<MoodEntry>> getMoodEntries() {
    if (_userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('moods')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MoodEntry.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<List<MoodEntry>> getMoodEntriesForDateRange(
      DateTime startDate, DateTime endDate) async {
    if (_userId == null) return [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('moods')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => MoodEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get mood entries: $e');
    }
  }

  // Journal Entries
  Future<void> saveJournalEntry(JournalEntry journalEntry) async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      if (journalEntry.id.isEmpty) {
        // Create new entry
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('journal')
            .add(journalEntry.toMap());
      } else {
        // Update existing entry
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('journal')
            .doc(journalEntry.id)
            .update(journalEntry.toMap());
      }
    } catch (e) {
      throw Exception('Failed to save journal entry: $e');
    }
  }

  Stream<List<JournalEntry>> getJournalEntries() {
    if (_userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('journal')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JournalEntry.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> deleteJournalEntry(String entryId) async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('journal')
          .doc(entryId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete journal entry: $e');
    }
  }

  // User Preferences
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .update({'preferences': preferences});
    } catch (e) {
      throw Exception('Failed to save preferences: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserPreferences() async {
    if (_userId == null) return null;

    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(_userId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['preferences'] as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get preferences: $e');
    }
  }

  // Daily Affirmation Tracking
  Future<void> markAffirmationViewed(DateTime date) async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      String dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('affirmations')
          .doc(dateKey)
          .set({
        'date': Timestamp.fromDate(date),
        'viewed': true,
        'viewedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to mark affirmation as viewed: $e');
    }
  }

  Future<bool> hasViewedTodaysAffirmation() async {
    if (_userId == null) return false;

    try {
      DateTime today = DateTime.now();
      String dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('affirmations')
          .doc(dateKey)
          .get();

      return doc.exists && (doc.data() as Map<String, dynamic>)['viewed'] == true;
    } catch (e) {
      return false;
    }
  }
}
