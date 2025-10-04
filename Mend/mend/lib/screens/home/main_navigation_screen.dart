import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mood/mood_tracker_screen.dart';
import '../journal/journal_screen.dart';
import '../meditation/meditation_screen.dart';
import '../mental_health/mental_health_info_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/settings_screen.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_constants.dart';
import 'home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigateToTab: _navigateToTab),
      const MoodTrackerScreen(),
      const JournalScreen(),
      const MeditationScreen(),
    ];
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      drawer: _buildDrawer(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood_outlined),
            activeIcon: Icon(Icons.mood),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement_outlined),
            activeIcon: Icon(Icons.self_improvement),
            label: 'Meditate',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.primaryColor,
                      AppConstants.secondaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                accountName: Text(
                  authProvider.user?.displayName ?? 'MEND User',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(
                  authProvider.user?.email ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    (authProvider.user?.displayName?.isNotEmpty == true)
                        ? authProvider.user!.displayName![0].toUpperCase()
                        : 'M',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ),
              );
            },
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  'Mental Health Info',
                  Icons.psychology,
                  () => _navigateToScreen(
                    context,
                    const MentalHealthInfoScreen(),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  'Profile',
                  Icons.person,
                  () => _navigateToScreen(context, const ProfileScreen()),
                ),
                _buildDrawerItem(
                  context,
                  'Settings',
                  Icons.settings,
                  () => _navigateToScreen(context, const SettingsScreen()),
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  'About MEND',
                  Icons.info,
                  () => _showAboutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.favorite, color: Colors.white, size: 32),
      ),
      children: [
        const Text(
          'MEND is your companion for mental wellness, providing tools for mood tracking, journaling, meditation, and mental health resources.',
        ),
      ],
    );
  }
}
