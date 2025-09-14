import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class ThemeToggleWidget extends StatefulWidget {
  final bool showLabel;
  final IconData? customIcon;
  final String? customLabel;

  const ThemeToggleWidget({
    super.key,
    this.showLabel = true,
    this.customIcon,
    this.customLabel,
  });

  @override
  State<ThemeToggleWidget> createState() => _ThemeToggleWidgetState();
}

class _ThemeToggleWidgetState extends State<ThemeToggleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    _animationController.forward().then((_) {
      final adaptiveTheme = AdaptiveTheme.of(context);
      if (adaptiveTheme.mode.isDark) {
        adaptiveTheme.setLight();
      } else {
        adaptiveTheme.setDark();
      }
      _animationController.reverse();
    });
  }

  IconData _getThemeIcon(AdaptiveThemeMode mode) {
    switch (mode) {
      case AdaptiveThemeMode.light:
        return Icons.light_mode;
      case AdaptiveThemeMode.dark:
        return Icons.dark_mode;
      case AdaptiveThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  String _getThemeModeString(AdaptiveThemeMode mode) {
    switch (mode) {
      case AdaptiveThemeMode.light:
        return 'Light';
      case AdaptiveThemeMode.dark:
        return 'Dark';
      case AdaptiveThemeMode.system:
        return 'System';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adaptiveTheme = AdaptiveTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.showLabel) {
      return ListTile(
        leading: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: Icon(
                widget.customIcon ?? _getThemeIcon(adaptiveTheme.mode),
                color: isDark ? Colors.amber : Colors.orange,
              ),
            );
          },
        ),
        title: Text(
          widget.customLabel ??
              'Theme: ${_getThemeModeString(adaptiveTheme.mode)}',
          style: theme.textTheme.bodyLarge,
        ),
        subtitle: Text(
          isDark ? 'Dark mode enabled' : 'Light mode enabled',
          style: theme.textTheme.bodyMedium,
        ),
        trailing: Switch.adaptive(
          key: const Key('theme_toggle_switch'),
          value: isDark,
          onChanged: (_) => _toggleTheme(),
          activeColor: theme.colorScheme.primary,
        ),
        onTap: _toggleTheme,
      );
    }

    return IconButton(
      onPressed: _toggleTheme,
      icon: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: Icon(
              widget.customIcon ?? _getThemeIcon(adaptiveTheme.mode),
              color: isDark ? Colors.amber : Colors.orange,
            ),
          );
        },
      ),
      tooltip: 'Toggle ${isDark ? 'light' : 'dark'} mode',
    );
  }
}

class ThemeSelectionWidget extends StatelessWidget {
  const ThemeSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final adaptiveTheme = AdaptiveTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: const Text('Theme Settings'),
          subtitle: const Text('Choose your preferred theme'),
          leading: const Icon(Icons.palette),
        ),
        const Divider(),
        RadioListTile<AdaptiveThemeMode>(
          key: const Key('system_theme_radio'),
          title: const Text('System Default'),
          subtitle: const Text('Follow system theme'),
          value: AdaptiveThemeMode.system,
          groupValue: adaptiveTheme.mode,
          onChanged: (value) {
            if (value != null) {
              adaptiveTheme.setSystem();
            }
          },
          secondary: const Icon(Icons.brightness_auto),
        ),
        RadioListTile<AdaptiveThemeMode>(
          key: const Key('light_theme_radio'),
          title: const Text('Light Theme'),
          subtitle: const Text('Always use light theme'),
          value: AdaptiveThemeMode.light,
          groupValue: adaptiveTheme.mode,
          onChanged: (value) {
            if (value != null) {
              adaptiveTheme.setLight();
            }
          },
          secondary: const Icon(Icons.light_mode),
        ),
        RadioListTile<AdaptiveThemeMode>(
          key: const Key('dark_theme_radio'),
          title: const Text('Dark Theme'),
          subtitle: const Text('Always use dark theme'),
          value: AdaptiveThemeMode.dark,
          groupValue: adaptiveTheme.mode,
          onChanged: (value) {
            if (value != null) {
              adaptiveTheme.setDark();
            }
          },
          secondary: const Icon(Icons.dark_mode),
        ),
      ],
    );
  }
}
