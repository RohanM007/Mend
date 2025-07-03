import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../services/notification_service.dart';
import 'auth/login_screen.dart';
import 'home/main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateAfterDelay();

    // Safety timeout - navigate after 10 seconds regardless
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _navigateToNextScreen();
      }
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  void _navigateAfterDelay() {
    // Wait for minimum splash time AND auth initialization
    Future.delayed(const Duration(milliseconds: 3000), () async {
      if (mounted) {
        await _waitForAuthInitialization();

        // Check if notifications need refreshing (with error handling)
        try {
          if (await NotificationService.shouldRefreshNotifications()) {
            await NotificationService.scheduleAllNotifications();
          }
        } catch (e) {
          // Continue even if notification setup fails
          debugPrint('Notification setup failed: $e');
        }
        _navigateToNextScreen();
      }
    });
  }

  Future<void> _waitForAuthInitialization() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Wait until auth is no longer uninitialized (max 5 seconds)
    int attempts = 0;
    while (authProvider.status == AuthStatus.uninitialized && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
  }

  void _navigateToNextScreen() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    Widget nextScreen;
    if (authProvider.status == AuthStatus.authenticated) {
      nextScreen = const MainNavigationScreen();
      debugPrint('User is authenticated, navigating to main screen');
    } else {
      nextScreen = const LoginScreen();
      debugPrint('User is not authenticated, navigating to login screen');
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusXLarge,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusXLarge,
                        ),
                        child: Image.asset(
                          'assets/images/logo.jpg',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to icon if logo fails to load
                            return const Icon(
                              Icons.healing,
                              size: 60,
                              color: AppConstants.primaryColor,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // App Name
                    Text(
                      AppConstants.appName,
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingSmall),

                    // App Description
                    Text(
                      AppConstants.appDescription,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppConstants.paddingXLarge),

                    // Loading indicator
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.8),
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
