import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../config/theme.dart';

class AnimatedLogo extends StatelessWidget {
  final double size;
  final bool animate;

  const AnimatedLogo({
    super.key,
    this.size = 120,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget logo = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkPrimary,
            AppColors.darkSecondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkPrimary.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: AppColors.darkSecondary.withOpacity(0.3),
            blurRadius: 40,
            offset: const Offset(10, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size * 0.25),
              child: CustomPaint(
                painter: _CodePatternPainter(),
              ),
            ),
          ),
          // HTML icon
          Icon(
            Icons.code,
            color: Colors.white,
            size: size * 0.5,
          ),
        ],
      ),
    );

    if (animate) {
      return logo
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(
            duration: 2000.ms,
            color: Colors.white.withOpacity(0.3),
          )
          .animate()
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
            duration: 600.ms,
            curve: Curves.easeOutBack,
          )
          .fadeIn(duration: 500.ms);
    }

    return logo;
  }
}

class _CodePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 10; i++) {
      final y = (size.height / 10) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width * 0.3, y),
        paint,
      );
    }

    for (int i = 0; i < 5; i++) {
      final y = (size.height / 5) * i + 10;
      canvas.drawLine(
        Offset(size.width * 0.5, y),
        Offset(size.width * 0.9, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnimatedAppTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final bool animate;

  const AnimatedAppTitle({
    super.key,
    required this.title,
    this.fontSize = 32,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget text = ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          AppColors.darkPrimary,
          AppColors.darkSecondary,
          AppColors.darkAccent,
        ],
      ).createShader(bounds),
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
      ),
    );

    if (animate) {
      return text
          .animate()
          .fadeIn(duration: 600.ms, delay: 300.ms)
          .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 300.ms);
    }

    return text;
  }
}
