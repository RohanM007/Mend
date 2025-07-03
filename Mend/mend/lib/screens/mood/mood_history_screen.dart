import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mood_provider.dart';
import '../../models/mood_entry.dart';
import '../../constants/app_constants.dart';
import '../../widgets/mood_selector.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({super.key});

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  MoodType? _filterMood;
  String _sortBy = 'date'; // 'date', 'mood', 'intensity'
  bool _ascending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood History'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                if (_sortBy == value) {
                  _ascending = !_ascending;
                } else {
                  _sortBy = value;
                  _ascending = false;
                }
              });
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'date',
                    child: Row(
                      children: [
                        Icon(
                          _sortBy == 'date'
                              ? (_ascending
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward)
                              : Icons.calendar_today,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const Text('Sort by Date'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'mood',
                    child: Row(
                      children: [
                        Icon(
                          _sortBy == 'mood'
                              ? (_ascending
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward)
                              : Icons.mood,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const Text('Sort by Mood'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'intensity',
                    child: Row(
                      children: [
                        Icon(
                          _sortBy == 'intensity'
                              ? (_ascending
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward)
                              : Icons.trending_up,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const Text('Sort by Intensity'),
                      ],
                    ),
                  ),
                ],
          ),
          IconButton(
            icon: Icon(
              _filterMood != null
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Consumer<MoodProvider>(
        builder: (context, moodProvider, child) {
          if (moodProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (moodProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppConstants.errorColor,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    'Error loading mood history',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    moodProvider.errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstants.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  ElevatedButton(
                    onPressed: () => moodProvider.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final entries = _getFilteredAndSortedEntries(
            moodProvider.moodEntries,
          );

          if (entries.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              if (_filterMood != null) _buildFilterChip(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => moodProvider.refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppConstants.paddingSmall,
                        ),
                        child: MoodDisplay(entry: entry),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mood_outlined,
              size: 80,
              color: AppConstants.textSecondary,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              _filterMood != null
                  ? 'No entries for this mood'
                  : 'No mood entries yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              _filterMood != null
                  ? 'Try adjusting your filter or log more moods.'
                  : 'Start tracking your moods to see your history here.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (_filterMood != null) ...[
              const SizedBox(height: AppConstants.paddingLarge),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _filterMood = null;
                  });
                },
                child: const Text('Clear Filter'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip() {
    final moodInfo = MoodInfo.getMoodInfo(_filterMood!);

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Chip(
        avatar: Text(moodInfo.emoji),
        label: Text('Filtered by ${moodInfo.label}'),
        onDeleted: () {
          setState(() {
            _filterMood = null;
          });
        },
        deleteIcon: const Icon(Icons.close, size: 18),
      ),
    );
  }

  List<MoodEntry> _getFilteredAndSortedEntries(List<MoodEntry> entries) {
    var filteredEntries = entries;

    // Apply filter
    if (_filterMood != null) {
      filteredEntries =
          entries.where((entry) => entry.mood == _filterMood).toList();
    }

    // Apply sorting
    filteredEntries.sort((a, b) {
      int comparison;

      switch (_sortBy) {
        case 'date':
          comparison = a.date.compareTo(b.date);
          break;
        case 'mood':
          comparison = a.mood.toString().compareTo(b.mood.toString());
          break;
        case 'intensity':
          comparison = a.intensity.compareTo(b.intensity);
          break;
        default:
          comparison = a.date.compareTo(b.date);
      }

      return _ascending ? comparison : -comparison;
    });

    return filteredEntries;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter by Mood'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.clear),
                    title: const Text('Show All'),
                    onTap: () {
                      setState(() {
                        _filterMood = null;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  const Divider(),
                  ...MoodType.values.map((mood) {
                    final moodInfo = MoodInfo.getMoodInfo(mood);
                    return ListTile(
                      leading: Text(
                        moodInfo.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(moodInfo.label),
                      onTap: () {
                        setState(() {
                          _filterMood = mood;
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
    );
  }
}
