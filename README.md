# HTML View

A professional, feature-rich Flutter application for creating, editing, and rendering HTML code with stunning animations and premium UI design.

## Features

### 🎨 Premium UI
- **Dark/Light Theme** - Beautiful glassmorphism-inspired design
- **Smooth Animations** - Micro-interactions throughout the app
- **Animated Splash Screen** - Logo reveal with particle effects

### 📝 Code Editor
- **Syntax Highlighting** - Easy-to-read HTML code
- **Line Numbers** - Professional coding experience
- **Auto-Save** - Never lose your work
- **Format Code** - Auto-format your HTML
- **Font Size Control** - Adjust to your preference

### 🚀 HTML Rendering
- **Live Preview** - See your HTML rendered instantly
- **WebView Powered** - Full HTML/CSS/JS support
- **Fullscreen Mode** - Immersive preview experience
- **Refresh** - Quickly reload your changes

### 📁 Project Management
- **Save Projects** - Keep all your HTML snippets organized
- **Templates** - Start with pre-built templates
- **Edit/Delete** - Full CRUD operations
- **Search** - Find projects quickly

### ⚙️ Settings
- **Theme Toggle** - Switch between dark/light mode
- **Editor Font Size** - Customize your experience
- **Auto-Save Toggle** - Enable/disable auto-saving
- **Word Wrap** - Toggle line wrapping

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio
- Android SDK

### Installation

1. Clone the repository or open the project folder

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

4. Build APK:
```bash
flutter build apk
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── config/
│   ├── theme.dart         # App themes
│   ├── constants.dart     # App constants
│   └── routes.dart        # Navigation routes
├── models/
│   └── html_project.dart  # Data model
├── providers/
│   ├── theme_provider.dart    # Theme state
│   └── project_provider.dart  # Projects state
├── screens/
│   ├── splash_screen.dart     # Animated splash
│   ├── home_screen.dart       # Project list
│   ├── editor_screen.dart     # Code editor
│   ├── preview_screen.dart    # HTML preview
│   └── settings_screen.dart   # Settings
└── widgets/
    ├── animated_logo.dart     # Logo widget
    ├── project_card.dart      # Project item
    ├── code_editor.dart       # Code editor
    ├── glass_container.dart   # Glass effect
    ├── animated_fab.dart      # FAB button
    └── custom_app_bar.dart    # App bar
```

## Screenshots

The app features:
- Gradient backgrounds
- Glassmorphism containers
- Animated transitions
- Professional typography

## Built With

- **Flutter** - UI framework
- **Provider** - State management
- **WebView Flutter** - HTML rendering
- **Flutter Animate** - Animations
- **Google Fonts** - Typography
- **Shared Preferences** - Local storage

## License

This project is open source and available under the MIT License.

---

Made with ❤️ using Flutter
