import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/journal_provider.dart';
import '../../models/journal_entry.dart';
import '../../constants/app_constants.dart';
import '../../widgets/journal_entry_card.dart';
import '../../widgets/custom_button.dart';
import 'write_journal_screen.dart';
import 'journal_entry_detail_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journal'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: Consumer<JournalProvider>(
        builder: (context, journalProvider, child) {
          if (journalProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (journalProvider.errorMessage != null) {
            return _buildErrorState(journalProvider);
          }

          final entries = _getFilteredEntries(journalProvider.journalEntries);

          if (entries.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              if (_searchQuery.isNotEmpty) _buildSearchHeader(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => journalProvider.refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppConstants.paddingSmall,
                        ),
                        child: JournalEntryCard(
                          entry: entry,
                          onTap: () => _navigateToDetail(entry),
                          onEdit: () => _navigateToEdit(entry),
                          onDelete: () => _showDeleteDialog(entry),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToWrite,
        icon: const Icon(Icons.edit),
        label: const Text('Write'),
      ),
    );
  }

  Widget _buildErrorState(JournalProvider journalProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
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
              'Error loading journal entries',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              journalProvider.errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            CustomButton(
              text: 'Retry',
              onPressed: () => journalProvider.refresh(),
            ),
          ],
        ),
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
              Icons.book_outlined,
              size: 80,
              color: AppConstants.textSecondary,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No entries found'
                  : 'Start Your Journal',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms.'
                  : 'Your thoughts and feelings are safe here.\nStart writing your first entry.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            if (_searchQuery.isEmpty)
              CustomButton(
                text: 'Write First Entry',
                onPressed: _navigateToWrite,
                icon: Icons.edit,
              )
            else
              CustomButton(
                text: 'Clear Search',
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                  });
                },
                isOutlined: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          const Icon(Icons.search, color: AppConstants.textSecondary),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: Text(
              'Searching for "$_searchQuery"',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  List<JournalEntry> _getFilteredEntries(List<JournalEntry> entries) {
    if (_searchQuery.isEmpty) return entries;

    return entries.where((entry) {
      final query = _searchQuery.toLowerCase();
      return entry.title.toLowerCase().contains(query) ||
          entry.content.toLowerCase().contains(query) ||
          entry.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Search Journal'),
            content: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search titles, content, or tags...',
                prefixIcon: Icon(Icons.search),
              ),
              autofocus: true,
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
                Navigator.of(context).pop();
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = _searchController.text.trim();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Search'),
              ),
            ],
          ),
    );
  }

  void _navigateToWrite() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const WriteJournalScreen()));
  }

  void _navigateToDetail(JournalEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => JournalEntryDetailScreen(entry: entry)),
    );
  }

  void _navigateToEdit(JournalEntry entry) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => WriteJournalScreen(entry: entry)));
  }

  void _showDeleteDialog(JournalEntry entry) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Entry'),
            content: Text('Are you sure you want to delete "${entry.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final journalProvider = Provider.of<JournalProvider>(
                    context,
                    listen: false,
                  );

                  navigator.pop();
                  try {
                    await journalProvider.deleteJournalEntry(entry.id);
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Entry deleted successfully'),
                          backgroundColor: AppConstants.successColor,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('Failed to delete entry: $e'),
                          backgroundColor: AppConstants.errorColor,
                        ),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppConstants.errorColor,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
