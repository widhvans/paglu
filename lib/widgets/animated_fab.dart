import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../config/theme.dart';

class AnimatedFab extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  final bool extended;
  final String? label;

  const AnimatedFab({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
    this.tooltip,
    this.extended = false,
    this.label,
  });

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          height: 56,
          padding: EdgeInsets.symmetric(
            horizontal: widget.extended ? 20 : 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.extended ? 28 : 16),
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.darkPrimary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: 24,
              ),
              if (widget.extended && widget.label != null) ...[
                const SizedBox(width: 8),
                Text(
                  widget.label!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 300.ms);
  }
}
