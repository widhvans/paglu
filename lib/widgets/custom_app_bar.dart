import 'dart:ui';
import 'package:flutter/material.dart';

import '../config/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool isTransparent;
  final Widget? bottom;
  final double? bottomHeight;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBackPressed,
    this.isTransparent = true,
    this.bottom,
    this.bottomHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottomHeight ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isTransparent
                ? (isDark
                    ? AppColors.darkBackground.withOpacity(0.8)
                    : AppColors.lightBackground.withOpacity(0.8))
                : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? AppColors.darkBorder.withOpacity(0.5)
                    : AppColors.lightBorder.withOpacity(0.5),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      // Leading
                      if (showBackButton)
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: isDark ? Colors.white : AppColors.lightText,
                          ),
                          onPressed:
                              onBackPressed ?? () => Navigator.pop(context),
                        )
                      else if (leading != null)
                        leading!
                      else
                        const SizedBox(width: 16),

                      // Title
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.lightText,
                          ),
                        ),
                      ),

                      // Actions
                      if (actions != null) ...actions!,
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                if (bottom != null) bottom!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                )
              else
                const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (actions != null) ...actions!,
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
