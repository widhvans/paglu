import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

import '../config/theme.dart';

class PreviewScreen extends StatefulWidget {
  final String htmlCode;
  final String title;

  const PreviewScreen({
    super.key,
    required this.htmlCode,
    required this.title,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
        ),
      );
    _loadHtml();
  }

  void _loadHtml() {
    final uri = Uri.dataFromString(
      widget.htmlCode,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    );
    _controller.loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBackgroundGradient : null,
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (!_isFullscreen) _buildAppBar(isDark),
              Expanded(
                child: Container(
                  margin: _isFullscreen ? EdgeInsets.zero : const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: _isFullscreen ? BorderRadius.zero : BorderRadius.circular(16),
                    boxShadow: _isFullscreen ? [] : [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: _isFullscreen ? BorderRadius.zero : BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        WebViewWidget(controller: _controller),
                        if (_isLoading) const Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms),
              ),
              if (!_isFullscreen) _buildBottomBar(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : AppColors.lightText),
        ),
        Expanded(
          child: Text(widget.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.lightText)),
        ),
        IconButton(onPressed: _loadHtml, icon: Icon(Icons.refresh, color: isDark ? Colors.white : AppColors.lightText)),
        IconButton(
          onPressed: () => setState(() => _isFullscreen = !_isFullscreen),
          icon: Icon(Icons.fullscreen, color: isDark ? Colors.white : AppColors.lightText),
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(onPressed: _loadHtml, icon: const Icon(Icons.refresh), label: const Text('Refresh')),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.edit), label: const Text('Edit')),
        ],
      ),
    );
  }
}
