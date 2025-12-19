import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../config/constants.dart';
import '../providers/theme_provider.dart';
import '../providers/project_provider.dart';
import '../widgets/glass_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBackgroundGradient : null,
          color: isDark ? null : AppColors.lightBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, isDark),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSection('Appearance', [
                      _buildThemeTile(context, isDark, themeProvider),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection('Editor', [
                      _buildFontSizeTile(isDark, themeProvider),
                      _buildSwitchTile('Auto Save', 'Automatically save changes', Icons.save, themeProvider.autoSave, (v) => themeProvider.setAutoSave(v), isDark),
                      _buildSwitchTile('Word Wrap', 'Wrap long lines', Icons.wrap_text, themeProvider.wordWrap, (v) => themeProvider.setWordWrap(v), isDark),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection('Data', [
                      _buildActionTile('Clear All Projects', 'Delete all saved projects', Icons.delete_forever, Colors.red, () => _confirmClearAll(context), isDark),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection('About', [
                      _buildInfoTile('Version', AppConstants.appVersion, Icons.info_outline, isDark),
                      _buildInfoTile('Developer', 'Made with ❤️', Icons.code, isDark),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : AppColors.lightText),
          ),
          Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.lightText)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkPrimary)),
        ),
        ...children,
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildThemeTile(BuildContext context, bool isDark, ThemeProvider themeProvider) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: AppColors.primaryGradient),
            child: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Theme', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightText)),
                Text(isDark ? 'Dark Mode' : 'Light Mode', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              ],
            ),
          ),
          Switch(value: isDark, onChanged: (_) => themeProvider.toggleTheme(), activeColor: AppColors.darkPrimary),
        ],
      ),
    );
  }

  Widget _buildFontSizeTile(bool isDark, ThemeProvider themeProvider) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: AppColors.primaryGradient),
                child: const Icon(Icons.text_fields, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Font Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightText)),
                    Text('${themeProvider.editorFontSize.toInt()}px', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: themeProvider.editorFontSize,
            min: 10, max: 24,
            divisions: 14,
            activeColor: AppColors.darkPrimary,
            onChanged: (v) => themeProvider.setEditorFontSize(v),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged, bool isDark) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: AppColors.primaryGradient),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightText)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: AppColors.darkPrimary),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, Color color, VoidCallback onTap, bool isDark) {
    return GlassContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: color.withOpacity(0.2)), child: Icon(icon, color: color)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon, bool isDark) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: AppColors.primaryGradient), child: Icon(icon, color: Colors.white)),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightText))),
          Text(value, style: TextStyle(fontSize: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Projects?'),
        content: const Text('This will permanently delete all your projects.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<ProjectProvider>().deleteAllProjects();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All projects deleted')));
            },
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
