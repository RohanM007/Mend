import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/journal_provider.dart';
import '../../models/journal_entry.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class WriteJournalScreen extends StatefulWidget {
  final JournalEntry? entry;

  const WriteJournalScreen({super.key, this.entry});

  @override
  State<WriteJournalScreen> createState() => _WriteJournalScreenState();
}

class _WriteJournalScreenState extends State<WriteJournalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  String? _selectedPrompt;
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _addListeners();
  }

  void _initializeFields() {
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
      _tagsController.text = widget.entry!.tags.join(', ');
      _selectedPrompt = widget.entry!.prompt;
    }
  }

  void _addListeners() {
    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
    _tagsController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _hasUnsavedChanges) {
          _showUnsavedChangesDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.entry == null ? 'New Entry' : 'Edit Entry'),
          actions: [
            if (_selectedPrompt == null)
              IconButton(
                icon: const Icon(Icons.lightbulb_outline),
                onPressed: _showPromptDialog,
                tooltip: 'Get writing prompt',
              ),
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save journal entry',
              onPressed: _isLoading ? null : _saveEntry,
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title field
                CustomTextField(
                  controller: _titleController,
                  labelText: 'Title',
                  hintText: 'Give your entry a title...',
                  maxLength: AppConstants.maxJournalTitleLength,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppConstants.paddingMedium),

                // Content field
                CustomTextField(
                  controller: _contentController,
                  labelText: 'Your thoughts',
                  hintText: _selectedPrompt ?? 'What\'s on your mind?',
                  maxLines: 15,
                  maxLength: AppConstants.maxJournalContentLength,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please write something';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppConstants.paddingMedium),

                // Tags field
                CustomTextField(
                  controller: _tagsController,
                  labelText: 'Tags (optional)',
                  hintText: 'mood, work, family, gratitude...',
                  prefixIcon: Icons.tag,
                ),

                const SizedBox(height: AppConstants.paddingSmall),

                // Tags help text
                Text(
                  'Separate tags with commas to organize your entries',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textSecondary,
                  ),
                ),

                const SizedBox(height: AppConstants.paddingLarge),

                // Word count
                _buildWordCount(),

                const SizedBox(height: AppConstants.paddingLarge),

                // Save button
                CustomButton(
                  text: widget.entry == null ? 'Save Entry' : 'Update Entry',
                  onPressed: _isLoading ? null : _saveEntry,
                  isLoading: _isLoading,
                  icon: Icons.save,
                ),

                const SizedBox(height: AppConstants.paddingMedium),

                // Cancel button
                CustomButton(
                  text: 'Cancel',
                  onPressed:
                      _isLoading ? null : () => Navigator.of(context).pop(),
                  isOutlined: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordCount() {
    final wordCount =
        _contentController.text.trim().isEmpty
            ? 0
            : _contentController.text.trim().split(RegExp(r'\s+')).length;

    return Row(
      children: [
        const Icon(
          Icons.text_fields,
          size: 16,
          color: AppConstants.textSecondary,
        ),
        const SizedBox(width: AppConstants.paddingSmall),
        Text(
          '$wordCount words',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppConstants.textSecondary),
        ),
      ],
    );
  }

  void _showPromptDialog() {
    final prompts = [
      ...JournalPrompts.dailyPrompts,
      ...JournalPrompts.reflectionPrompts,
      ...JournalPrompts.spiritualPrompts,
    ];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Choose a Writing Prompt'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: prompts.length,
                itemBuilder: (context, index) {
                  final prompt = prompts[index];
                  return ListTile(
                    title: Text(
                      prompt,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedPrompt = prompt;
                        // Auto-populate the title field with the selected prompt
                        _titleController.text = prompt;
                        _hasUnsavedChanges = true;
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final randomPrompt = JournalPrompts.getRandomPrompt();
                  setState(() {
                    _selectedPrompt = randomPrompt;
                    // Auto-populate the title field with the random prompt
                    _titleController.text = randomPrompt;
                    _hasUnsavedChanges = true;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Random'),
              ),
            ],
          ),
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text(
              'You have unsaved changes. Do you want to discard them?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Close screen
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppConstants.errorColor,
                ),
                child: const Text('Discard'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      final tags =
          _tagsController.text
              .split(',')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList();

      final entry = JournalEntry(
        id: widget.entry?.id ?? '',
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        prompt: _selectedPrompt,
        createdAt: widget.entry?.createdAt ?? now,
        updatedAt: now,
        tags: tags,
      );

      await Provider.of<JournalProvider>(
        context,
        listen: false,
      ).saveJournalEntry(entry);

      if (mounted) {
        setState(() {
          _hasUnsavedChanges = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.entry == null
                  ? 'Entry saved successfully!'
                  : 'Entry updated successfully!',
            ),
            backgroundColor: AppConstants.successColor,
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save entry: $e'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
