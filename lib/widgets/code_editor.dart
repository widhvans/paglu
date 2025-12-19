import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/theme.dart';

class CodeEditor extends StatefulWidget {
  final String initialCode;
  final ValueChanged<String>? onChanged;
  final double fontSize;
  final bool wordWrap;
  final bool readOnly;
  final TextEditingController? controller;

  const CodeEditor({
    super.key,
    this.initialCode = '',
    this.onChanged,
    this.fontSize = 14,
    this.wordWrap = true,
    this.readOnly = false,
    this.controller,
  });

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  int _lineCount = 1;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialCode);
    _scrollController = ScrollController();
    _updateLineCount();
    _controller.addListener(_updateLineCount);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _updateLineCount() {
    final lines = '\n'.allMatches(_controller.text).length + 1;
    if (lines != _lineCount) {
      setState(() {
        _lineCount = lines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line Numbers
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              children: List.generate(
                _lineCount,
                (index) => SizedBox(
                  height: widget.fontSize * 1.5,
                  child: Text(
                    '${index + 1}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: widget.fontSize,
                      color: isDark
                          ? AppColors.darkTextSecondary.withOpacity(0.5)
                          : AppColors.lightTextSecondary.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Code Editor
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: IntrinsicWidth(
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onChanged,
                  readOnly: widget.readOnly,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: widget.fontSize,
                    height: 1.5,
                    color: isDark ? Colors.white : AppColors.lightText,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                    hintText: 'Paste your HTML code here...',
                    hintStyle: GoogleFonts.jetBrainsMono(
                      fontSize: widget.fontSize,
                      color: isDark
                          ? AppColors.darkTextSecondary.withOpacity(0.5)
                          : AppColors.lightTextSecondary.withOpacity(0.5),
                    ),
                  ),
                  cursorColor: AppColors.darkPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SyntaxHighlightedText extends StatelessWidget {
  final String code;
  final double fontSize;

  const SyntaxHighlightedText({
    super.key,
    required this.code,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.jetBrainsMono(
          fontSize: fontSize,
          height: 1.5,
        ),
        children: _buildSpans(code, context),
      ),
    );
  }

  List<TextSpan> _buildSpans(String code, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<TextSpan> spans = [];
    
    // Simple syntax highlighting
    final tagPattern = RegExp(r'<[^>]+>');
    final stringPattern = RegExp(r'"[^"]*"');
    
    int lastEnd = 0;
    
    for (final match in tagPattern.allMatches(code)) {
      // Add text before tag
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: code.substring(lastEnd, match.start),
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.lightText,
          ),
        ));
      }
      
      // Add tag with color
      spans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(
          color: isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
        ),
      ));
      
      lastEnd = match.end;
    }
    
    // Add remaining text
    if (lastEnd < code.length) {
      spans.add(TextSpan(
        text: code.substring(lastEnd),
        style: TextStyle(
          color: isDark ? Colors.white : AppColors.lightText,
        ),
      ));
    }
    
    return spans.isEmpty
        ? [TextSpan(text: code, style: TextStyle(color: isDark ? Colors.white : AppColors.lightText))]
        : spans;
  }
}
