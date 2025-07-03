import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../providers/meditation_provider.dart';
import '../../models/meditation.dart';
import '../../constants/app_constants.dart';

class MeditationPlayerScreen extends StatefulWidget {
  final Meditation meditation;

  const MeditationPlayerScreen({super.key, required this.meditation});

  @override
  State<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _rippleController;
  late Animation<double> _breathingAnimation;

  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isPlaying = false;
  MeditationSession? _currentSession;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.meditation.durationMinutes * 60;
    _setupAnimations();
    _startSession();
  }

  void _setupAnimations() {
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _breathingController.repeat(reverse: true);
    _rippleController.repeat();
  }

  Future<void> _startSession() async {
    try {
      final session = await Provider.of<MeditationProvider>(
        context,
        listen: false,
      ).startMeditationSession(widget.meditation);
      setState(() {
        _currentSession = session;
      });
      _startMeditation();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start session: $e'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  void _startMeditation() {
    setState(() {
      _isPlaying = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _completeMeditation();
      }
    });
  }

  void _pauseMeditation() {
    setState(() {
      _isPlaying = false;
    });
    _timer?.cancel();
  }

  void _resumeMeditation() {
    _startMeditation();
  }

  void _stopMeditation() {
    _timer?.cancel();
    if (_currentSession != null) {
      Provider.of<MeditationProvider>(
        context,
        listen: false,
      ).cancelMeditationSession(_currentSession!);
    }
    Navigator.of(context).pop();
  }

  void _completeMeditation() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });

    if (_currentSession != null) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => _CompletionDialog(
            meditation: widget.meditation,
            session: _currentSession!,
            onComplete: (rating, notes) async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final meditationProvider = Provider.of<MeditationProvider>(
                context,
                listen: false,
              );

              try {
                await meditationProvider.completeMeditationSession(
                  _currentSession!,
                  rating: rating,
                  notes: notes,
                );
                if (mounted) {
                  navigator.pop(); // Close dialog
                  navigator.pop(); // Close player
                }
              } catch (e) {
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Failed to save session: $e'),
                      backgroundColor: AppConstants.errorColor,
                    ),
                  );
                }
              }
            },
          ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathingController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitDialog();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Main content
              Expanded(child: _buildMainContent()),

              // Controls
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: _showExitDialog,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  widget.meditation.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.meditation.instructor != null)
                  Text(
                    'with ${widget.meditation.instructor}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 48), // Balance the close button
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Breathing animation
          AnimatedBuilder(
            animation: _breathingAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _breathingAnimation.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppConstants.primaryColor.withValues(alpha: 0.3),
                        AppConstants.primaryColor.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConstants.primaryColor.withValues(alpha: 0.8),
                      ),
                      child: const Icon(
                        Icons.self_improvement,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppConstants.paddingXLarge),

          // Timer
          Text(
            _formatTime(_remainingSeconds),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Progress bar
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor:
                  1 -
                  (_remainingSeconds /
                      (widget.meditation.durationMinutes * 60)),
              child: Container(
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingLarge),

          // Breathing instruction
          if (_isPlaying)
            AnimatedBuilder(
              animation: _breathingController,
              builder: (context, child) {
                final isInhaling = _breathingController.value < 0.5;
                return Text(
                  isInhaling ? 'Breathe In' : 'Breathe Out',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white70),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Stop button
          IconButton(
            icon: const Icon(Icons.stop, color: Colors.white, size: 32),
            onPressed: _showExitDialog,
          ),

          // Play/Pause button
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppConstants.primaryColor,
            ),
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
              onPressed: _isPlaying ? _pauseMeditation : _resumeMeditation,
            ),
          ),

          // Settings button (placeholder)
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 32),
            onPressed: () {
              // Could open settings for background sounds, etc.
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('End Meditation?'),
            content: const Text(
              'Are you sure you want to end this meditation session?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continue'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  _stopMeditation();
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppConstants.errorColor,
                ),
                child: const Text('End Session'),
              ),
            ],
          ),
    );
  }
}

class _CompletionDialog extends StatefulWidget {
  final Meditation meditation;
  final MeditationSession session;
  final Function(double?, String?) onComplete;

  const _CompletionDialog({
    required this.meditation,
    required this.session,
    required this.onComplete,
  });

  @override
  State<_CompletionDialog> createState() => _CompletionDialogState();
}

class _CompletionDialogState extends State<_CompletionDialog> {
  double _rating = 5.0;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Meditation Complete! 🧘‍♀️'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Great job completing "${widget.meditation.title}"!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: AppConstants.paddingLarge),

          // Rating
          Text(
            'How was your session?',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppConstants.paddingSmall),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1.0;
                  });
                },
              );
            }),
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Notes
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'How do you feel?',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => widget.onComplete(null, null),
          child: const Text('Skip'),
        ),
        ElevatedButton(
          onPressed:
              () => widget.onComplete(
                _rating,
                _notesController.text.trim().isEmpty
                    ? null
                    : _notesController.text.trim(),
              ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
