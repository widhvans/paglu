import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../config/routes.dart';
import '../config/constants.dart';
import '../providers/project_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/code_editor.dart';

class EditorScreen extends StatefulWidget {
  final String? projectId;
  final String? initialCode;

  const EditorScreen({
    super.key,
    this.projectId,
    this.initialCode,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _codeController;
  late TextEditingController _titleController;
  bool _isEdited = false;
  bool _isSaving = false;
  String? _currentProjectId;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _titleController = TextEditingController(text: 'Untitled Project');
    _currentProjectId = widget.projectId;
    _loadProject();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _loadProject() {
    if (widget.projectId != null) {
      final project = context.read<ProjectProvider>().getProject(widget.projectId!);
      if (project != null) {
        _codeController.text = project.code;
        _titleController.text = project.title;
      }
    } else if (widget.initialCode != null) {
      _codeController.text = widget.initialCode!;
    } else {
      _codeController.text = AppConstants.defaultHtmlTemplate;
    }
  }

  void _onCodeChanged(String value) {
    if (!_isEdited) {
      setState(() {
        _isEdited = true;
      });
    }
    
    // Auto-save if enabled
    final autoSave = context.read<ThemeProvider>().autoSave;
    if (autoSave && _currentProjectId != null) {
      _autoSave();
    }
  }

  void _autoSave() async {
    if (_currentProjectId != null) {
      await context.read<ProjectProvider>().updateProject(
        _currentProjectId!,
        code: _codeController.text,
        title: _titleController.text,
      );
    }
  }

  Future<void> _saveProject() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final projectProvider = context.read<ProjectProvider>();
      
      if (_currentProjectId != null) {
        await projectProvider.updateProject(
          _currentProjectId!,
          code: _codeController.text,
          title: _titleController.text,
        );
      } else {
        final project = await projectProvider.addProject(
          title: _titleController.text,
          code: _codeController.text,
        );
        _currentProjectId = project.id;
      }

      setState(() {
        _isEdited = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Project saved successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _runCode() {
    if (_codeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some HTML code first!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.preview,
      arguments: {
        'htmlCode': _codeController.text,
        'title': _titleController.text,
      },
    );
  }

  void _formatCode() {
    // Simple HTML formatting
    String formatted = _codeController.text;
    
    // Add newlines after closing tags
    formatted = formatted.replaceAllMapped(
      RegExp(r'>([\s]*)<'),
      (match) => '>\n<',
    );
    
    _codeController.text = formatted;
    setState(() {
      _isEdited = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code formatted!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _codeController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.copy, color: Colors.white),
            SizedBox(width: 12),
            Text('Code copied to clipboard!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _pasteCode() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _codeController.text = data!.text!;
      setState(() {
        _isEdited = true;
      });
    }
  }

  void _clearCode() {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Clear Code?',
            style: TextStyle(color: isDark ? Colors.white : AppColors.lightText),
          ),
          content: Text(
            'This will clear all the code in the editor.',
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
              onPressed: () {
                _codeController.clear();
                setState(() {
                  _isEdited = true;
                });
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showTitleDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Project Title',
          style: TextStyle(color: isDark ? Colors.white : AppColors.lightText),
        ),
        content: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'Enter project title...',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isEdited = true;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    return WillPopScope(
      onWillPop: () async {
        if (_isEdited) {
          final shouldSave = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Save Changes?',
                style: TextStyle(color: isDark ? Colors.white : AppColors.lightText),
              ),
              content: Text(
                'You have unsaved changes. Would you like to save before leaving?',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Discard'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Save'),
                ),
              ],
            ),
          );

          if (shouldSave == true) {
            await _saveProject();
          }
        }
        return true;
      },
      child: Scaffold(
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
                // App Bar
                _buildAppBar(isDark),
                
                // Toolbar
                _buildToolbar(isDark),
                
                // Code Editor
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CodeEditor(
                      controller: _codeController,
                      onChanged: _onCodeChanged,
                      fontSize: themeProvider.editorFontSize,
                      wordWrap: themeProvider.wordWrap,
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                ),
                
                // Bottom Action Bar
                _buildBottomBar(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : AppColors.lightText,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _showTitleDialog,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      _titleController.text,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.lightText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_isEdited)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.darkAccent,
                      ),
                    ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.edit,
                    size: 16,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_isSaving)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              onPressed: _saveProject,
              icon: Icon(
                Icons.save_outlined,
                color: _isEdited
                    ? AppColors.darkPrimary
                    : (isDark ? Colors.white : AppColors.lightText),
              ),
            ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: isDark ? Colors.white : AppColors.lightText,
            ),
            onSelected: (value) {
              switch (value) {
                case 'format':
                  _formatCode();
                  break;
                case 'copy':
                  _copyCode();
                  break;
                case 'paste':
                  _pasteCode();
                  break;
                case 'clear':
                  _clearCode();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'format',
                child: Row(
                  children: [
                    Icon(Icons.auto_fix_high, size: 20),
                    SizedBox(width: 12),
                    Text('Format Code'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.copy, size: 20),
                    SizedBox(width: 12),
                    Text('Copy All'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'paste',
                child: Row(
                  children: [
                    Icon(Icons.paste, size: 20),
                    SizedBox(width: 12),
                    Text('Paste'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Clear All', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(bool isDark) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withOpacity(0.5)
            : AppColors.lightSurface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildToolbarButton(
              icon: Icons.undo,
              onTap: () {
                // Undo functionality would require more complex state management
              },
              isDark: isDark,
            ),
            _buildToolbarButton(
              icon: Icons.redo,
              onTap: () {},
              isDark: isDark,
            ),
            _buildToolbarDivider(isDark),
            _buildToolbarButton(
              icon: Icons.copy,
              onTap: _copyCode,
              isDark: isDark,
            ),
            _buildToolbarButton(
              icon: Icons.paste,
              onTap: _pasteCode,
              isDark: isDark,
            ),
            _buildToolbarDivider(isDark),
            _buildToolbarButton(
              icon: Icons.auto_fix_high,
              onTap: _formatCode,
              isDark: isDark,
            ),
            _buildToolbarButton(
              icon: Icons.text_increase,
              onTap: () {
                final themeProvider = context.read<ThemeProvider>();
                themeProvider.setEditorFontSize(themeProvider.editorFontSize + 1);
              },
              isDark: isDark,
            ),
            _buildToolbarButton(
              icon: Icons.text_decrease,
              onTap: () {
                final themeProvider = context.read<ThemeProvider>();
                themeProvider.setEditorFontSize(themeProvider.editorFontSize - 1);
              },
              isDark: isDark,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2);
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildToolbarDivider(bool isDark) {
    return Container(
      width: 1,
      height: 24,
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withOpacity(0.8)
            : AppColors.lightSurface.withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          // Character count
          Text(
            '${_codeController.text.length} characters',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const Spacer(),
          // Save button
          OutlinedButton.icon(
            onPressed: _saveProject,
            icon: const Icon(Icons.save_outlined, size: 18),
            label: const Text('Save'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Run button
          ElevatedButton.icon(
            onPressed: _runCode,
            icon: const Icon(Icons.play_arrow, size: 20),
            label: const Text('Run'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2);
  }
}
