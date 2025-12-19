class AppConstants {
  // Animation Durations
  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration pageTransitionDuration = Duration(milliseconds: 400);
  static const Duration microAnimationDuration = Duration(milliseconds: 200);
  static const Duration staggerDelay = Duration(milliseconds: 100);
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // App Info
  static const String appName = 'HTML View';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A professional HTML code editor and renderer';
  
  // Storage Keys
  static const String projectsKey = 'html_projects';
  static const String themeKey = 'app_theme';
  static const String fontSizeKey = 'editor_font_size';
  static const String autoSaveKey = 'auto_save';
  static const String wordWrapKey = 'word_wrap';
  
  // Default HTML Template
  static const String defaultHtmlTemplate = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My HTML Page</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: white;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }
        h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        p {
            font-size: 1.2rem;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎉 Welcome to HTML View!</h1>
        <p>Start editing this code to see your changes live.</p>
    </div>
</body>
</html>
''';

  // Sample Templates
  static const List<Map<String, String>> sampleTemplates = [
    {
      'name': 'Basic Page',
      'icon': 'description',
      'code': '''<!DOCTYPE html>
<html>
<head>
    <title>Basic Page</title>
</head>
<body>
    <h1>Hello World!</h1>
    <p>This is a basic HTML page.</p>
</body>
</html>''',
    },
    {
      'name': 'Styled Card',
      'icon': 'style',
      'code': '''<!DOCTYPE html>
<html>
<head>
    <style>
        body { 
            font-family: Arial; 
            background: #f0f0f0; 
            padding: 20px; 
        }
        .card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            max-width: 400px;
            margin: 0 auto;
        }
        h2 { color: #333; margin-top: 0; }
        p { color: #666; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Beautiful Card</h2>
        <p>A modern styled card component.</p>
    </div>
</body>
</html>''',
    },
    {
      'name': 'Gradient Hero',
      'icon': 'gradient',
      'code': '''<!DOCTYPE html>
<html>
<head>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #6366f1, #8b5cf6, #d946ef);
            font-family: system-ui;
        }
        .hero {
            text-align: center;
            color: white;
        }
        h1 { 
            font-size: 3rem; 
            margin-bottom: 1rem;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        p { 
            font-size: 1.25rem; 
            opacity: 0.9; 
        }
    </style>
</head>
<body>
    <div class="hero">
        <h1>✨ Amazing Gradient</h1>
        <p>Create stunning visual experiences</p>
    </div>
</body>
</html>''',
    },
    {
      'name': 'Button Showcase',
      'icon': 'smart_button',
      'code': '''<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: system-ui;
            padding: 40px;
            background: #1a1a2e;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
        }
        .btn {
            padding: 12px 32px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }
        .primary {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white;
        }
        .success {
            background: linear-gradient(135deg, #10b981, #34d399);
            color: white;
        }
        .danger {
            background: linear-gradient(135deg, #ef4444, #f87171);
            color: white;
        }
    </style>
</head>
<body>
    <button class="btn primary">Primary Button</button>
    <button class="btn success">Success Button</button>
    <button class="btn danger">Danger Button</button>
</body>
</html>''',
    },
  ];
}
