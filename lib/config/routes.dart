import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/editor_screen.dart';
import '../screens/preview_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String editor = '/editor';
  static const String preview = '/preview';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildPageRoute(const SplashScreen(), settings);
      case home:
        return _buildPageRoute(const HomeScreen(), settings);
      case editor:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildPageRoute(
          EditorScreen(
            projectId: args?['projectId'],
            initialCode: args?['initialCode'],
          ),
          settings,
        );
      case preview:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildPageRoute(
          PreviewScreen(
            htmlCode: args['htmlCode'],
            title: args['title'] ?? 'Preview',
          ),
          settings,
        );
      case AppRoutes.settings:
        return _buildPageRoute(const SettingsScreen(), settings);
      default:
        return _buildPageRoute(const HomeScreen(), settings);
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
