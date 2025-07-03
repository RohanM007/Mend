import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../constants/app_constants.dart';

class JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const JournalEntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and actions
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: AppConstants.errorColor),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: AppConstants.errorColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingSmall),

              // Date and reading time
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppConstants.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(entry.createdAt),
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
                    '${entry.readingTimeMinutes} min read',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingSmall),

              // Content preview
              Text(
                entry.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Prompt indicator
              if (entry.prompt != null) ...[
                const SizedBox(height: AppConstants.paddingSmall),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        size: 12,
                        color: AppConstants.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Prompt-based',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Tags
              if (entry.tags.isNotEmpty) ...[
                const SizedBox(height: AppConstants.paddingSmall),
                Wrap(
                  spacing: AppConstants.paddingSmall,
                  runSpacing: 4,
                  children: entry.tags.take(3).map((tag) => _buildTag(context, tag)).toList(),
                ),
              ],

              const SizedBox(height: AppConstants.paddingSmall),

              // Footer with word count and updated indicator
              Row(
                children: [
                  Icon(
                    Icons.text_fields,
                    size: 14,
                    color: AppConstants.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${entry.wordCount} words',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (entry.updatedAt != entry.createdAt)
                    Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 14,
                          color: AppConstants.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Updated ${_formatDate(entry.updatedAt)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Text(
        tag,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppConstants.textSecondary,
          fontSize: 11,
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
      return 'Today';
    } else if (entryDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[date.weekday - 1];
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class JournalEntryListTile extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;

  const JournalEntryListTile({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        entry.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                _formatDate(entry.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.textSecondary,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Text(
                '${entry.wordCount} words',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
        child: Text(
          entry.title.isNotEmpty ? entry.title[0].toUpperCase() : 'J',
          style: const TextStyle(
            color: AppConstants.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: entry.prompt != null
          ? const Icon(
              Icons.lightbulb,
              size: 16,
              color: AppConstants.primaryColor,
            )
          : null,
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'Today';
    } else if (entryDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
