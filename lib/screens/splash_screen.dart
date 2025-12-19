import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../config/theme.dart';
import '../config/routes.dart';
import '../widgets/animated_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.darkBackgroundGradient,
        ),
        child: Stack(
          children: [
            // Animated background particles
            ..._buildParticles(),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  const AnimatedLogo(size: 120),
                  
                  const SizedBox(height: 32),
                  
                  // App Title
                  const AnimatedAppTitle(
                    title: 'HTML View',
                    fontSize: 36,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Tagline
                  Text(
                    'Code • Preview • Create',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.darkTextSecondary.withOpacity(0.8),
                      letterSpacing: 2,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 600.ms)
                      .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 600.ms),
                  
                  const SizedBox(height: 60),
                  
                  // Loading indicator
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.darkSecondary.withOpacity(0.8),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 1000.ms)
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.0, 1.0),
                        duration: 400.ms,
                        delay: 1000.ms,
                      ),
                ],
              ),
            ),
            
            // Bottom branding
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Text(
                'Made with ❤️ by Developer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.darkTextSecondary.withOpacity(0.5),
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 1200.ms),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildParticles() {
    return List.generate(15, (index) {
      final random = index * 0.1;
      return Positioned(
        left: (index * 50.0) % MediaQuery.of(context).size.width,
        top: (index * 80.0) % MediaQuery.of(context).size.height,
        child: Container(
          width: 4 + (index % 3) * 2.0,
          height: 4 + (index % 3) * 2.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven
                ? AppColors.darkPrimary.withOpacity(0.3)
                : AppColors.darkSecondary.withOpacity(0.3),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .fadeIn(duration: 1000.ms, delay: Duration(milliseconds: (random * 500).toInt()))
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.2, 1.2),
              duration: 2000.ms,
            )
            .moveY(
              begin: 0,
              end: -20,
              duration: 3000.ms,
            ),
      );
    });
  }
}
