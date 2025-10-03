import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../constants/app_constants.dart';

class MoodSelector extends StatelessWidget {
  final MoodType? selectedMood;
  final Function(MoodType) onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary moods (most common)
        _buildMoodRow(context, [
          MoodType.veryHappy,
          MoodType.happy,
          MoodType.neutral,
          MoodType.sad,
          MoodType.verySad,
        ]),

        const SizedBox(height: AppConstants.paddingMedium),

        // Secondary moods (emotional states)
        _buildMoodRow(context, [
          MoodType.excited,
          MoodType.calm,
          MoodType.anxious,
          MoodType.stressed,
          MoodType.angry,
        ]),
      ],
    );
  }

  Widget _buildMoodRow(BuildContext context, List<MoodType> moods) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: moods.map((mood) => _buildMoodButton(context, mood)).toList(),
    );
  }

  Widget _buildMoodButton(BuildContext context, MoodType mood) {
  final moodInfo = MoodInfo.getMoodInfo(mood);
  final isSelected = selectedMood == mood;

  return GestureDetector(
    onTap: () => onMoodSelected(mood),
    child: AnimatedContainer(
      duration: AppConstants.animationMedium,
      // Remove fixed width/height
      constraints: BoxConstraints.tightFor(
        width: 72,    // Slightly more room
        height: 92,   // Extra vertical space for 2-line labels
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? Color(int.parse(moodInfo.color.replaceFirst('#', '0xFF')))
                .withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: isSelected
              ? Color(int.parse(moodInfo.color.replaceFirst('#', '0xFF')))
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              moodInfo.emoji,
              style: TextStyle(fontSize: isSelected ? 28 : 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                moodInfo.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Color(int.parse(moodInfo.color.replaceFirst('#', '0xFF')))
                      : AppConstants.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class MoodDisplay extends StatelessWidget {
  final MoodEntry entry;
  final bool showIntensity;
  final bool showNote;

  const MoodDisplay({
    super.key,
    required this.entry,
    this.showIntensity = true,
    this.showNote = true,
  });

  @override
  Widget build(BuildContext context) {
    final moodInfo = MoodInfo.getMoodInfo(entry.mood);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(moodInfo.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moodInfo.label,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Color(
                            int.parse(moodInfo.color.replaceFirst('#', '0xFF')),
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatDate(entry.date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showIntensity)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingSmall,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(moodInfo.color.replaceFirst('#', '0xFF')),
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSmall,
                      ),
                    ),
                    child: Text(
                      '${entry.intensity}/10',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Color(
                          int.parse(moodInfo.color.replaceFirst('#', '0xFF')),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            if (showNote && entry.note != null && entry.note!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Text(
                  entry.note!,
                  style: Theme.of(context).textTheme.bodyMedium,
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
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'Today at ${_formatTime(date)}';
    } else if (entryDate == yesterday) {
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

class MoodSummaryCard extends StatelessWidget {
  final Map<MoodType, double> moodSummary;
  final double averageIntensity;

  const MoodSummaryCard({
    super.key,
    required this.moodSummary,
    required this.averageIntensity,
  });

  @override
  Widget build(BuildContext context) {
    if (moodSummary.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            children: [
              const Icon(
                Icons.mood_outlined,
                size: 48,
                color: AppConstants.textSecondary,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                'No mood data yet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppConstants.textSecondary,
                ),
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                'Start logging your moods to see insights here.',
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

    final sortedMoods =
        moodSummary.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mood Summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppConstants.paddingMedium),

            // Average intensity
            Row(
              children: [
                const Icon(Icons.analytics, color: AppConstants.primaryColor),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'Average Intensity: ${averageIntensity.toStringAsFixed(1)}/10',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // Mood breakdown
            ...sortedMoods.take(3).map((entry) {
              final moodInfo = MoodInfo.getMoodInfo(entry.key);
              final percentage = (entry.value * 100).round();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(moodInfo.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Expanded(
                      child: Text(
                        moodInfo.label,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Color(
                          int.parse(moodInfo.color.replaceFirst('#', '0xFF')),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
