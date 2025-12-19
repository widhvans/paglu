import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../models/html_project.dart';

class ProjectProvider with ChangeNotifier {
  List<HtmlProject> _projects = [];
  bool _isLoading = true;
  String? _searchQuery;

  List<HtmlProject> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get searchQuery => _searchQuery;

  List<HtmlProject> get filteredProjects {
    if (_searchQuery == null || _searchQuery!.isEmpty) {
      return _projects;
    }
    return _projects
        .where((p) => p.title.toLowerCase().contains(_searchQuery!.toLowerCase()))
        .toList();
  }

  ProjectProvider() {
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = prefs.getString(AppConstants.projectsKey) ?? '';
      _projects = HtmlProject.decodeProjects(projectsJson);
      
      // Sort by updated date (newest first)
      _projects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      _projects = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveProjects() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.projectsKey,
      HtmlProject.encodeProjects(_projects),
    );
  }

  Future<HtmlProject> addProject({
    required String title,
    required String code,
  }) async {
    final project = HtmlProject(
      title: title,
      code: code,
    );
    
    _projects.insert(0, project);
    await _saveProjects();
    notifyListeners();
    
    return project;
  }

  Future<void> updateProject(String id, {String? title, String? code}) async {
    final index = _projects.indexWhere((p) => p.id == id);
    if (index == -1) return;

    _projects[index] = _projects[index].copyWith(
      title: title,
      code: code,
      updatedAt: DateTime.now(),
    );
    
    // Re-sort by updated date
    _projects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    
    await _saveProjects();
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
    await _saveProjects();
    notifyListeners();
  }

  Future<void> deleteAllProjects() async {
    _projects.clear();
    await _saveProjects();
    notifyListeners();
  }

  HtmlProject? getProject(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void setSearchQuery(String? query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadProjects();
  }

  Future<void> duplicateProject(String id) async {
    final original = getProject(id);
    if (original == null) return;

    await addProject(
      title: '${original.title} (Copy)',
      code: original.code,
    );
  }
}
