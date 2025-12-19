import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../config/theme.dart';
import '../models/html_project.dart';
import 'glass_container.dart';

class ProjectCard extends StatelessWidget {
  final HtmlProject project;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final VoidCallback? onRun;
  final int index;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
    this.onRun,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      onTap: onTap,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: AppColors.primaryGradient,
                ),
                child: const Icon(
                  Icons.code,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Title and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.lightText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Menu Button
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit?.call();
                      break;
                    case 'run':
                      onRun?.call();
                      break;
                    case 'duplicate':
                      onDuplicate?.call();
                      break;
                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'run',
                    child: Row(
                      children: [
                        Icon(Icons.play_arrow, size: 20),
                        SizedBox(width: 12),
                        Text('Run'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Duplicate'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Code Preview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              project.codePreview,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          // Action Buttons Row
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: onEdit,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: Icons.play_arrow,
                  label: 'Run',
                  onTap: onRun,
                  isPrimary: true,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 100 * index))
        .slideX(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
          delay: Duration(milliseconds: 100 * index),
        );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;
  final bool isDark;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isPrimary = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: isPrimary ? AppColors.primaryGradient : null,
            color: isPrimary
                ? null
                : (isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isPrimary
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isPrimary
                      ? Colors.white
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
