import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../constants/app_constants.dart';
import '../../data/wellness_data.dart';
import '../../widgets/affirmation_card.dart';
import '../../widgets/wellness_tip_card.dart';
import '../../widgets/quick_mood_check.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with gradient
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/logo.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.healing, color: Colors.white);
                  },
                ),
              ),
            ),
            actions: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return IconButton(
                    icon: Icon(
                      themeProvider.themeMode == ThemeMode.dark
                          ? Icons.light_mode
                          : themeProvider.themeMode == ThemeMode.light
                          ? Icons.dark_mode
                          : Icons.brightness_auto,
                      color: Colors.white,
                    ),
                    onPressed: () => themeProvider.toggleTheme(),
                    tooltip: 'Toggle theme',
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.gradientStart,
                      AppConstants.gradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            final user = authProvider.user;
                            return Text(
                              user != null
                                  ? 'Welcome back, ${_getFirstName(user.displayName ?? 'Friend')}!'
                                  : 'Welcome to ${AppConstants.appName}',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getGreeting(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Mood Check
                  const QuickMoodCheck(),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Daily Affirmation
                  _buildDailyAffirmation(context),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Daily Quote
                  _buildDailyQuote(context),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Wellness Tip
                  _buildWellnessTip(context),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Quick Actions
                  _buildQuickActions(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyAffirmation(BuildContext context) {
    final affirmation = WellnessData.getDailyAffirmation();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Affirmation',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        AffirmationCard(affirmation: affirmation),
      ],
    );
  }

  Widget _buildDailyQuote(BuildContext context) {
    final quote = WellnessData.getDailyQuote();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Inspiration',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            color: AppConstants.lightPurple,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(
              color: AppConstants.secondaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.format_quote,
                color: AppConstants.secondaryColor,
                size: 32,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                quote.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                '— ${quote.author}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppConstants.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWellnessTip(BuildContext context) {
    final tip = WellnessData.getRandomWellnessTip();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wellness Tip',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        WellnessTipCard(tip: tip),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Row(
          children: [
            _buildQuickActionCard(
              context,
              'Log Mood',
              Icons.mood,
              AppConstants.primaryColor,
              () => onNavigateToTab?.call(1),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            _buildQuickActionCard(
              context,
              'Write',
              Icons.edit,
              AppConstants.accentColor,
              () => onNavigateToTab?.call(2),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Row(
          children: [
            _buildQuickActionCard(
              context,
              'Meditate',
              Icons.self_improvement,
              AppConstants.secondaryColor,
              () => onNavigateToTab?.call(3),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            _buildQuickActionCard(
              context,
              'Learn',
              Icons.psychology,
              AppConstants.primaryColor,
              () => onNavigateToTab?.call(4),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusSmall,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning! How are you feeling today?';
    } else if (hour < 17) {
      return 'Good afternoon! Take a moment for yourself.';
    } else {
      return 'Good evening! Time to unwind and reflect.';
    }
  }

  String _getFirstName(String fullName) {
    return fullName.split(' ').first;
  }
}
