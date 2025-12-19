import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../config/routes.dart';
import '../config/constants.dart';
import '../providers/project_provider.dart';
import '../providers/theme_provider.dart';
import '../models/html_project.dart';
import '../widgets/project_card.dart';
import '../widgets/animated_fab.dart';
import '../widgets/glass_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projectProvider = context.watch<ProjectProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkBackgroundGradient
              : const LinearGradient(
                  colors: [AppColors.lightBackground, Color(0xFFE8ECEF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildAppBar(isDark, themeProvider),
              
              // Search Bar (when searching)
              if (_isSearching)
                _buildSearchBar(isDark, projectProvider),
              
              // Content
              Expanded(
                child: projectProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : projectProvider.filteredProjects.isEmpty
                        ? _buildEmptyState(isDark)
                        : _buildProjectList(projectProvider),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFab(
        onPressed: () => _showAddOptions(context),
        icon: Icons.add,
        extended: true,
        label: 'New',
      ),
    );
  }

  Widget _buildAppBar(bool isDark, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: AppColors.primaryGradient,
            ),
            child: const Icon(
              Icons.code,
              color: Colors.white,
              size: 22,
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          
          const SizedBox(width: 12),
          
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HTML View',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.lightText,
                  ),
                ),
                Text(
                  'Your HTML Projects',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
          
          // Search Button
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<ProjectProvider>().setSearchQuery(null);
                }
              });
            },
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: isDark ? Colors.white : AppColors.lightText,
            ),
          ),
          
          // Theme Toggle
          IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.white : AppColors.lightText,
            ),
          ),
          
          // Settings
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            icon: Icon(
              Icons.settings_outlined,
              color: isDark ? Colors.white : AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, ProjectProvider projectProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (value) => projectProvider.setSearchQuery(value),
        decoration: InputDecoration(
          hintText: 'Search projects...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    projectProvider.setSearchQuery(null);
                  },
                )
              : null,
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.3);
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightBorder.withOpacity(0.5),
            ),
            child: Icon(
              Icons.code_off_outlined,
              size: 50,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Projects Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first HTML project',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddOptions(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Project'),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  Widget _buildProjectList(ProjectProvider projectProvider) {
    return RefreshIndicator(
      onRefresh: () => projectProvider.refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: projectProvider.filteredProjects.length,
        itemBuilder: (context, index) {
          final project = projectProvider.filteredProjects[index];
          return ProjectCard(
            project: project,
            index: index,
            onTap: () => _openEditor(project),
            onEdit: () => _openEditor(project),
            onRun: () => _runProject(project),
            onDuplicate: () => projectProvider.duplicateProject(project.id),
            onDelete: () => _confirmDelete(project),
          );
        },
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Create New Project',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 24),
            
            // Options
            _buildOptionTile(
              icon: Icons.add_circle_outline,
              title: 'Blank Project',
              subtitle: 'Start with empty HTML',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                _createBlankProject();
              },
            ),
            _buildOptionTile(
              icon: Icons.description_outlined,
              title: 'Use Template',
              subtitle: 'Start with a preset template',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                _showTemplateSelector();
              },
            ),
            _buildOptionTile(
              icon: Icons.content_paste,
              title: 'Paste Code',
              subtitle: 'Paste your HTML code directly',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.editor);
              },
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: AppColors.primaryGradient,
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.lightText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
      onTap: onTap,
    );
  }

  void _createBlankProject() async {
    final projectProvider = context.read<ProjectProvider>();
    final project = await projectProvider.addProject(
      title: 'Untitled Project',
      code: AppConstants.defaultHtmlTemplate,
    );
    if (mounted) {
      Navigator.pushNamed(
        context,
        AppRoutes.editor,
        arguments: {'projectId': project.id},
      );
    }
  }

  void _showTemplateSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose a Template',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: AppConstants.sampleTemplates.length,
                itemBuilder: (context, index) {
                  final template = AppConstants.sampleTemplates[index];
                  return _buildTemplateTile(
                    name: template['name']!,
                    code: template['code']!,
                    isDark: isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateTile({
    required String name,
    required String code,
    required bool isDark,
  }) {
    return GlassContainer(
      onTap: () async {
        Navigator.pop(context);
        final projectProvider = context.read<ProjectProvider>();
        final project = await projectProvider.addProject(
          title: name,
          code: code,
        );
        if (mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.editor,
            arguments: {'projectId': project.id},
          );
        }
      },
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: AppColors.primaryGradient,
            ),
            child: const Icon(Icons.description, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${code.length} characters',
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
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ],
      ),
    );
  }

  void _openEditor(HtmlProject project) {
    Navigator.pushNamed(
      context,
      AppRoutes.editor,
      arguments: {'projectId': project.id},
    );
  }

  void _runProject(HtmlProject project) {
    Navigator.pushNamed(
      context,
      AppRoutes.preview,
      arguments: {
        'htmlCode': project.code,
        'title': project.title,
      },
    );
  }

  void _confirmDelete(HtmlProject project) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Project?',
          style: TextStyle(color: isDark ? Colors.white : AppColors.lightText),
        ),
        content: Text(
          'This will permanently delete "${project.title}". This action cannot be undone.',
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              context.read<ProjectProvider>().deleteProject(project.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
