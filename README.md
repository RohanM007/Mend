# 🌱 Mend - Your Personal Mental Wellness Companion

<div align="center">
  <img src="Mend/mend/assets/images/logo.jpg" alt="Mend Logo" width="120" height="120" style="border-radius: 20px;">

  <p><em>A comprehensive Flutter mental health app designed to support your wellness journey through mood tracking, journaling, meditation, and educational resources.</em></p>

  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
</div>

## 📱 About Mend

Mend is a mental health and wellness application built with Flutter that provides users with tools to track their mental health journey, practice mindfulness, and access educational resources. The app focuses on creating a safe, supportive environment for users to monitor their emotional well-being and develop healthy coping strategies.

## ✨ Features

### 🎯 **Mood Tracking**
- Daily mood logging with intensity levels (1-10)
- Visual mood history and trends
- Optional notes for context and reflection
- Quick mood check-ins from the home screen

### 📝 **Digital Journaling**
- Guided journal prompts for self-reflection
- Free-form writing with rich text support
- Tag system for organizing entries
- Search and filter functionality
- Edit and delete existing entries

### 🧘 **Meditation & Mindfulness**
- Guided meditation sessions
- Multiple meditation types: guided, music, nature sounds, breathing exercises
- Session tracking and progress monitoring
- Customizable meditation durations
- Post-session reflection and rating

### 📚 **Mental Health Education**
- Curated mental health information and resources
- Wellness tips and educational content
- Daily affirmations and inspirational quotes
- Evidence-based mental health strategies

### 👤 **User Profile & Settings**
- Personalized user profiles
- Theme customization (light/dark mode)
- Privacy and security settings
- Data export capabilities

### 🏠 **Personalized Dashboard**
- Daily wellness overview
- Quick access to all features
- Motivational content
- Progress summaries

## 🛠️ Technology Stack

### **Frontend**
- **Flutter** - Cross-platform mobile development framework
- **Dart** - Programming language
- **Provider** - State management solution
- **Material Design** - UI/UX design system

### **Backend & Services**
- **Firebase Core** - Backend infrastructure
- **Firebase Authentication** - User authentication and security
- **Cloud Firestore** - NoSQL database for data storage
- **Firebase Storage** - File and media storage

### **Key Dependencies**
- **fl_chart** - Beautiful charts for mood tracking visualization
- **google_fonts** - Custom typography
- **audioplayers** - Audio playback for meditation
- **shared_preferences** - Local data persistence
- **intl** - Internationalization and date formatting
- **go_router** - Advanced navigation
- **url_launcher** - External link handling

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase account and project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/mend.git
   cd mend/Mend/mend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication, Firestore, and Storage
   - Download and add configuration files:
     - `google-services.json` for Android (place in `android/app/`)
     - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)

4. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Configuration

1. **Authentication**
   - Enable Email/Password authentication
   - Configure sign-in methods as needed

2. **Firestore Database**
   - Create a Firestore database
   - Set up security rules for user data protection

3. **Storage**
   - Enable Firebase Storage for media files
   - Configure storage security rules

## 📁 Project Structure

```
lib/
├── constants/          # App-wide constants and themes
├── data/              # Static data and sample content
├── models/            # Data models and entities
├── providers/         # State management (Provider pattern)
├── screens/           # UI screens and pages
│   ├── auth/         # Authentication screens
│   ├── home/         # Home and navigation
│   ├── mood/         # Mood tracking features
│   ├── journal/      # Journaling functionality
│   ├── meditation/   # Meditation and mindfulness
│   ├── mental_health/ # Educational content
│   └── profile/      # User profile and settings
├── services/          # Business logic and API services
├── widgets/           # Reusable UI components
└── main.dart         # App entry point
```

## 🎨 Design Philosophy

Mend follows a calming and accessible design approach:

- **Color Palette**: Soothing blues, greens, and purples to promote tranquility
- **Typography**: Clean, readable fonts with proper contrast
- **Accessibility**: Designed with mental health considerations in mind
- **User Experience**: Intuitive navigation and minimal cognitive load

## 🔒 Privacy & Security

- **Data Encryption**: All user data is encrypted in transit and at rest
- **Privacy First**: No personal data is shared with third parties
- **Local Storage**: Sensitive information is stored securely on device
- **User Control**: Users have full control over their data with export/delete options

## 🧪 Testing

Run the test suite:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12.0+)
- 🔄 **Web** (In development)
- 🔄 **Desktop** (Planned)

## 🤝 Contributing

We welcome contributions to make Mend better! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Write tests for new features
- Update documentation as needed
- Ensure accessibility compliance
- Test on multiple devices/screen sizes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Firebase Team** - For robust backend services
- **Mental Health Community** - For guidance and feedback
- **Open Source Contributors** - For various packages and tools

## 📞 Support & Contact

- **Issues**: [GitHub Issues](https://github.com/yourusername/mend/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/mend/discussions)
- **Email**: support@mendapp.com

## 🗺️ Roadmap

### Upcoming Features
- [ ] Social support groups
- [ ] Professional therapist connections
- [ ] Advanced analytics and insights
- [ ] Wearable device integration
- [ ] Multi-language support
- [ ] Offline mode improvements

### Version History
- **v1.0.0** - Initial release with core features
  - Mood tracking
  - Digital journaling
  - Meditation sessions
  - Educational resources
  - User profiles

---

<div align="center">
  <p><strong>Made with ❤️ for mental health awareness</strong></p>
  <p><em>Remember: This app is a tool to support your wellness journey, but it's not a replacement for professional mental health care. If you're experiencing a mental health crisis, please seek immediate professional help.</em></p>
</div>
