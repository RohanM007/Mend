import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mood_provider.dart';
import '../../models/mood_entry.dart';
import '../../constants/app_constants.dart';
import '../../widgets/mood_selector.dart';
import '../../widgets/mood_chart.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'mood_history_screen.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MoodType? _selectedMood;
  int _intensity = 5;
  final _noteController = TextEditingController();
  bool _hasLoggedToday = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkTodaysMood();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _checkTodaysMood() {
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    _hasLoggedToday = moodProvider.hasLoggedToday();
  }

  Future<void> _saveMoodEntry() async {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a mood'),
          backgroundColor: AppConstants.warningColor,
        ),
      );
      return;
    }

    final moodProvider = Provider.of<MoodProvider>(context, listen: false);

    final entry = MoodEntry(
      id: '',
      mood: _selectedMood!,
      intensity: _intensity,
      note:
          _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
      date: DateTime.now(),
      createdAt: DateTime.now(),
    );

    try {
      await moodProvider.saveMoodEntry(entry);

      if (mounted) {
        setState(() {
          _hasLoggedToday = true;
          _selectedMood = null;
          _intensity = 5;
          _noteController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mood logged successfully!'),
            backgroundColor: AppConstants.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save mood: $e'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Log', icon: Icon(Icons.add_reaction)),
            Tab(text: 'Insights', icon: Icon(Icons.analytics)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MoodHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildMoodLogTab(), _buildInsightsTab()],
      ),
    );
  }

  Widget _buildMoodLogTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Today's status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                children: [
                  Text(
                    'Today - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  if (_hasLoggedToday)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppConstants.successColor,
                        ),
                        const SizedBox(width: AppConstants.paddingSmall),
                        Text(
                          'Mood logged for today',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppConstants.successColor),
                        ),
                      ],
                    )
                  else
                    Text(
                      'How are you feeling today?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppConstants.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingLarge),

          // Mood selector
          if (!_hasLoggedToday) ...[
            Text(
              'Select Your Mood',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            MoodSelector(
              selectedMood: _selectedMood,
              onMoodSelected: (mood) {
                setState(() {
                  _selectedMood = mood;
                });
              },
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Intensity slider
            if (_selectedMood != null) ...[
              Text(
                'Intensity Level: $_intensity/10',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppConstants.paddingSmall),

              Slider(
                value: _intensity.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: _intensity.toString(),
                onChanged: (value) {
                  setState(() {
                    _intensity = value.round();
                  });
                },
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Note field
              CustomTextField(
                controller: _noteController,
                labelText: 'Add a note (optional)',
                hintText: 'What\'s on your mind?',
                maxLines: 3,
                maxLength: AppConstants.maxMoodNoteLength,
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Save button
              CustomButton(
                text: 'Log Mood',
                onPressed: _saveMoodEntry,
                icon: Icons.save,
              ),
            ],
          ] else ...[
            // Already logged today message
            Card(
              color: AppConstants.successColor.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    const Icon(
                      Icons.sentiment_satisfied_alt,
                      size: 60,
                      color: AppConstants.successColor,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      'Great job!',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: AppConstants.successColor),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      'You\'ve already logged your mood for today. Check back tomorrow!',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    CustomButton(
                      text: 'View History',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MoodHistoryScreen(),
                          ),
                        );
                      },
                      isOutlined: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return Consumer<MoodProvider>(
      builder: (context, moodProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Weekly chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Week',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      SizedBox(
                        height: 200,
                        child: MoodChart(
                          entries: moodProvider.weeklyEntries,
                          period: ChartPeriod.week,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Monthly chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Month',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      SizedBox(
                        height: 200,
                        child: MoodChart(
                          entries: moodProvider.monthlyEntries,
                          period: ChartPeriod.month,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Mood summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mood Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      _buildMoodSummary(moodProvider),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoodSummary(MoodProvider moodProvider) {
    final summary = moodProvider.getMoodSummary();

    if (summary.isEmpty) {
      return Text(
        'Start logging your moods to see insights here.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppConstants.textSecondary),
      );
    }

    return Column(
      children:
          summary.entries.map((entry) {
            final moodInfo = MoodInfo.getMoodInfo(entry.key);
            final percentage = (entry.value * 100).round();

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.paddingSmall,
              ),
              child: Row(
                children: [
                  Text(moodInfo.emoji, style: const TextStyle(fontSize: 24)),
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
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
