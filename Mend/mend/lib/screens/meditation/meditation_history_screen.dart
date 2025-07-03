import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/meditation_provider.dart';
import '../../models/meditation.dart';
import '../../constants/app_constants.dart';

class MeditationHistoryScreen extends StatelessWidget {
  const MeditationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation History'),
      ),
      body: Consumer<MeditationProvider>(
        builder: (context, meditationProvider, child) {
          final sessions = meditationProvider.getRecentSessions();
          
          if (sessions.isEmpty) {
            return _buildEmptyState(context);
          }

          return Column(
            children: [
              // Statistics
              _buildStatistics(context, meditationProvider),
              
              // Sessions list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return _buildSessionCard(context, session, meditationProvider);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history,
              size: 80,
              color: AppConstants.textSecondary,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              'No meditation history yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'Complete your first meditation to see your progress here.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, MeditationProvider provider) {
    final streak = provider.getMeditationStreak();
    final totalSessions = provider.getTotalSessions();
    final totalMinutes = provider.getTotalMinutes();
    final averageRating = provider.getAverageRating();

    return Card(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Progress',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Row(
              children: [
                _buildStatItem(context, 'Streak', '$streak days', Icons.local_fire_department),
                _buildStatItem(context, 'Sessions', '$totalSessions', Icons.self_improvement),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Row(
              children: [
                _buildStatItem(context, 'Minutes', '$totalMinutes', Icons.schedule),
                _buildStatItem(context, 'Rating', averageRating.toStringAsFixed(1), Icons.star),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingSmall),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppConstants.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppConstants.primaryColor, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, MeditationSession session, MeditationProvider provider) {
    // Find the meditation for this session
    final meditation = provider.meditations.firstWhere(
      (m) => m.id == session.meditationId,
      orElse: () => Meditation(
        id: session.meditationId,
        title: 'Unknown Meditation',
        description: '',
        category: '',
        durationMinutes: session.durationMinutes,
        type: MeditationType.guided,
        createdAt: DateTime.now(),
      ),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    meditation.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (session.rating != null)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        session.rating!.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingSmall),
            
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppConstants.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(session.startTime),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: AppConstants.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${session.durationMinutes} min',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
            
            if (session.notes != null && session.notes!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Text(
                  session.notes!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sessionDate = DateTime(date.year, date.month, date.day);

    if (sessionDate == today) {
      return 'Today at ${_formatTime(date)}';
    } else if (sessionDate == yesterday) {
      return 'Yesterday at ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year} at ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
