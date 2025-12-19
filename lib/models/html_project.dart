import 'dart:convert';
import 'package:uuid/uuid.dart';

class HtmlProject {
  final String id;
  String title;
  String code;
  final DateTime createdAt;
  DateTime updatedAt;

  HtmlProject({
    String? id,
    required this.title,
    required this.code,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  HtmlProject copyWith({
    String? title,
    String? code,
    DateTime? updatedAt,
  }) {
    return HtmlProject(
      id: id,
      title: title ?? this.title,
      code: code ?? this.code,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory HtmlProject.fromJson(Map<String, dynamic> json) {
    return HtmlProject(
      id: json['id'],
      title: json['title'],
      code: json['code'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  static String encodeProjects(List<HtmlProject> projects) {
    return jsonEncode(projects.map((p) => p.toJson()).toList());
  }

  static List<HtmlProject> decodeProjects(String jsonString) {
    if (jsonString.isEmpty) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => HtmlProject.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Get a preview snippet of the code (first 100 chars)
  String get codePreview {
    final cleanCode = code.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (cleanCode.length <= 100) return cleanCode;
    return '${cleanCode.substring(0, 100)}...';
  }

  // Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);
    
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes == 0) {
          return 'Just now';
        }
        return '${diff.inMinutes} min ago';
      }
      return '${diff.inHours} hr ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${updatedAt.day}/${updatedAt.month}/${updatedAt.year}';
    }
  }
}
