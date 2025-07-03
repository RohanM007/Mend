import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/meditation.dart';

class MeditationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // Get all available meditations
  Future<List<Meditation>> getMeditations() async {
    try {
      // For now, return default meditations
      // In a real app, you'd fetch from Firestore
      return DefaultMeditations.defaultMeditations;
    } catch (e) {
      throw Exception('Failed to load meditations: $e');
    }
  }

  // Get meditation sessions for current user
  Stream<List<MeditationSession>> getMeditationSessions() {
    if (_userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('meditation_sessions')
        .orderBy('startTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => MeditationSession.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  // Start a new meditation session
  Future<MeditationSession> startMeditationSession(
    Meditation meditation,
  ) async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      final session = MeditationSession(
        id: '',
        meditationId: meditation.id,
        userId: _userId!,
        startTime: DateTime.now(),
        durationMinutes: meditation.durationMinutes,
      );

      final docRef = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('meditation_sessions')
          .add(session.toMap());

      return session.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to start meditation session: $e');
    }
  }

  // Complete a meditation session
  Future<void> completeMeditationSession(
    MeditationSession session, {
    double? rating,
    String? notes,
  }) async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('meditation_sessions')
          .doc(session.id)
          .update({
            'endTime': Timestamp.fromDate(DateTime.now()),
            'completed': true,
            'rating': rating,
            'notes': notes,
          });
    } catch (e) {
      throw Exception('Failed to complete meditation session: $e');
    }
  }

  // Cancel a meditation session
  Future<void> cancelMeditationSession(MeditationSession session) async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('meditation_sessions')
          .doc(session.id)
          .delete();
    } catch (e) {
      throw Exception('Failed to cancel meditation session: $e');
    }
  }

  // Get meditation by ID
  Future<Meditation?> getMeditationById(String id) async {
    try {
      final meditations = await getMeditations();
      return meditations.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get sessions for a specific meditation
  Future<List<MeditationSession>> getSessionsForMeditation(
    String meditationId,
  ) async {
    if (_userId == null) return [];

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('meditation_sessions')
              .where('meditationId', isEqualTo: meditationId)
              .orderBy('startTime', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => MeditationSession.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get sessions for meditation: $e');
    }
  }

  // Get meditation statistics
  Future<Map<String, dynamic>> getMeditationStats() async {
    if (_userId == null) return {};

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('meditation_sessions')
              .where('completed', isEqualTo: true)
              .get();

      final sessions =
          snapshot.docs
              .map((doc) => MeditationSession.fromMap(doc.data(), doc.id))
              .toList();

      final totalSessions = sessions.length;
      final totalMinutes = sessions.fold<int>(
        0,
        (total, session) => total + session.durationMinutes,
      );

      final averageRating =
          sessions.where((s) => s.rating != null).isEmpty
              ? 0.0
              : sessions
                      .where((s) => s.rating != null)
                      .fold<double>(
                        0.0,
                        (total, session) => total + session.rating!,
                      ) /
                  sessions.where((s) => s.rating != null).length;

      return {
        'totalSessions': totalSessions,
        'totalMinutes': totalMinutes,
        'averageRating': averageRating,
        'lastSession': sessions.isNotEmpty ? sessions.first.startTime : null,
      };
    } catch (e) {
      throw Exception('Failed to get meditation stats: $e');
    }
  }

  // Update session rating
  Future<void> updateSessionRating(String sessionId, double rating) async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('meditation_sessions')
          .doc(sessionId)
          .update({'rating': rating});
    } catch (e) {
      throw Exception('Failed to update session rating: $e');
    }
  }

  // Add session notes
  Future<void> addSessionNotes(String sessionId, String notes) async {
    if (_userId == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('meditation_sessions')
          .doc(sessionId)
          .update({'notes': notes});
    } catch (e) {
      throw Exception('Failed to add session notes: $e');
    }
  }
}
