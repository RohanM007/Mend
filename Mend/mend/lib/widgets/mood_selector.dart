import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../constants/app_constants.dart';

class MoodSelector extends StatelessWidget {
  final List<MoodType> selectedMoods;
  final Function(MoodType) onMoodToggled;
  final VoidCallback? onClearAll;

  const MoodSelector({
    super.key,
    required this.selectedMoods,
    required this.onMoodToggled,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with mood count and clear button
        if (selectedMoods.isNotEmpty) _buildHeader(context),

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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${selectedMoods.length} mood${selectedMoods.length == 1 ? '' : 's'} selected',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (onClearAll != null)
            TextButton(
              onPressed: onClearAll,
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMoodRow(BuildContext context, List<MoodType> moods) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            moods
                .map(
                  (mood) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: _buildMoodButton(context, mood),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildMoodButton(BuildContext context, MoodType mood) {
    final moodInfo = MoodInfo.getMoodInfo(mood);
    final isSelected = selectedMoods.contains(mood);

    return GestureDetector(
      onTap: () => onMoodToggled(mood),
      child: AnimatedContainer(
        duration: AppConstants.animationMedium,
        // Use flexible height, remove fixed width
        constraints: const BoxConstraints(minHeight: 85, maxHeight: 100),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Color(
                    int.parse(moodInfo.color.replaceFirst('#', '0xFF')),
                  ).withValues(alpha: 0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color:
                isSelected
                    ? Color(int.parse(moodInfo.color.replaceFirst('#', '0xFF')))
                    : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                moodInfo.emoji,
                style: TextStyle(fontSize: isSelected ? 26 : 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  moodInfo.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 11,
                    color:
                        isSelected
                            ? Color(
                              int.parse(
                                moodInfo.color.replaceFirst('#', '0xFF'),
                              ),
                            )
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Display multiple mood emojis
                Wrap(
                  spacing: 4,
                  children:
                      entry.moods.take(3).map((mood) {
                        final moodInfo = MoodInfo.getMoodInfo(mood);
                        return Text(
                          moodInfo.emoji,
                          style: const TextStyle(fontSize: 28),
                        );
                      }).toList(),
                ),
                if (entry.moods.length > 3)
                  Text(
                    ' +${entry.moods.length - 3}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMoodLabelsText(),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                      color: AppConstants.primaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSmall,
                      ),
                    ),
                    child: Text(
                      '${entry.intensity}/10',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryColor,
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

  String _getMoodLabelsText() {
    if (entry.moods.isEmpty) return 'No mood';
    if (entry.moods.length == 1) {
      return MoodInfo.getMoodInfo(entry.moods.first).label;
    }

    // For multiple moods, show first two and count
    final labels = entry.moods
        .take(2)
        .map((mood) => MoodInfo.getMoodInfo(mood).label);
    if (entry.moods.length == 2) {
      return labels.join(' & ');
    } else {
      return '${labels.join(', ')} & ${entry.moods.length - 2} more';
    }
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
