import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class QuickMoodCheck extends StatefulWidget {
  const QuickMoodCheck({super.key});

  @override
  State<QuickMoodCheck> createState() => _QuickMoodCheckState();
}

class _QuickMoodCheckState extends State<QuickMoodCheck> {
  String? _selectedMood;

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😊', 'label': 'Great', 'color': AppConstants.successColor},
    {'emoji': '🙂', 'label': 'Good', 'color': AppConstants.accentColor},
    {'emoji': '😐', 'label': 'Okay', 'color': AppConstants.warningColor},
    {'emoji': '😔', 'label': 'Low', 'color': AppConstants.errorColor},
    {'emoji': '😰', 'label': 'Anxious', 'color': AppConstants.primaryColor},
  ];

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
                Icon(Icons.mood, color: AppConstants.primaryColor, size: 24),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'Quick Mood Check',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'How are you feeling right now?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Mood options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _moods.map((mood) => _buildMoodOption(mood)).toList(),
            ),

            if (_selectedMood != null) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppConstants.lightBlue,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppConstants.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Expanded(
                      child: Text(
                        'Mood logged! Visit the Mood tab for detailed tracking.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.primaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMoodOption(Map<String, dynamic> mood) {
    final isSelected = _selectedMood == mood['label'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = mood['label'];
        });
        _logMood(mood);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? mood['color'].withValues(alpha: 0.2)
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: isSelected ? mood['color'] : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mood['emoji'], style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 2),
            Text(
              mood['label'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? mood['color'] : AppConstants.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logMood(Map<String, dynamic> mood) {
    // Here you would typically save the mood to your data store
    // For now, we'll just show a brief feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood "${mood['label']}" logged!'),
        backgroundColor: mood['color'],
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
