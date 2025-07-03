import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/journal_entry.dart';
import '../../constants/app_constants.dart';
import 'write_journal_screen.dart';

class JournalEntryDetailScreen extends StatelessWidget {
  final JournalEntry entry;

  const JournalEntryDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareEntry(context),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editEntry(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              entry.title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // Metadata
            _buildMetadata(context),

            const SizedBox(height: AppConstants.paddingLarge),

            // Prompt (if exists)
            if (entry.prompt != null) _buildPromptSection(context),

            // Content
            _buildContentSection(context),

            // Tags
            if (entry.tags.isNotEmpty) _buildTagsSection(context),

            const SizedBox(height: AppConstants.paddingLarge),

            // Statistics
            _buildStatistics(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'Created: ${_formatDateTime(entry.createdAt)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            if (entry.updatedAt != entry.createdAt) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              Row(
                children: [
                  const Icon(Icons.edit, size: 16),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Text(
                    'Updated: ${_formatDateTime(entry.updatedAt)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPromptSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: AppConstants.primaryColor.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb,
                      color: AppConstants.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Text(
                      'Writing Prompt',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  entry.prompt!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppConstants.paddingLarge),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Entry',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        SelectableText(
          entry.content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.paddingLarge),
        Text(
          'Tags',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Wrap(
          spacing: AppConstants.paddingSmall,
          runSpacing: AppConstants.paddingSmall,
          children: entry.tags.map((tag) => _buildTag(context, tag)).toList(),
        ),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: AppConstants.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        tag,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppConstants.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  Icons.text_fields,
                  'Words',
                  entry.wordCount.toString(),
                ),
                _buildStatItem(
                  context,
                  Icons.schedule,
                  'Reading Time',
                  '${entry.readingTimeMinutes} min',
                ),
                _buildStatItem(
                  context,
                  Icons.tag,
                  'Tags',
                  entry.tags.length.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppConstants.primaryColor),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryColor,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final entryDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (entryDate == today) {
      dateStr = 'Today';
    } else if (entryDate == yesterday) {
      dateStr = 'Yesterday';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr at $timeStr';
  }

  void _shareEntry(BuildContext context) {
    final shareText = '''
${entry.title}

${entry.content}

${entry.tags.isNotEmpty ? '\nTags: ${entry.tags.join(', ')}' : ''}

Written on ${_formatDateTime(entry.createdAt)}
''';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Entry copied to clipboard'),
        backgroundColor: AppConstants.successColor,
      ),
    );
  }

  void _editEntry(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WriteJournalScreen(entry: entry),
      ),
    );
  }
}
