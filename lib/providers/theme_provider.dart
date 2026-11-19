import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../themes/app_colors.dart';

const _storage = FlutterSecureStorage();

class ThemeSettings {
  final bool isDarkMode;
  final int colorIndex;

  const ThemeSettings({this.isDarkMode = false, this.colorIndex = 0});

  Color get primaryColor => AppColors.themeColors[colorIndex];

  ThemeSettings copyWith({bool? isDarkMode, int? colorIndex}) {
    return ThemeSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }
}

class ThemeController extends Notifier<ThemeSettings> {
  static const String _darkModeKey = 'isDark';
  static const String _colorIndexKey = 'colorIndex';

  @override
  ThemeSettings build() {
    return const ThemeSettings();
  }

  Future<void> loadSettings() async {
    try {
      final darkMode = await _storage.read(key: _darkModeKey);
      final colorIndex = await _storage.read(key: _colorIndexKey);

      final parsedIndex = int.tryParse(colorIndex ?? '') ?? 0;

      state = ThemeSettings(
        isDarkMode: darkMode == 'true',
        colorIndex:
            parsedIndex >= 0 && parsedIndex < AppColors.themeColors.length
            ? parsedIndex
            : 0,
      );
    } catch (e) {
      // Keep default theme settings if storage fails.
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    state = state.copyWith(isDarkMode: value);

    await _storage.write(key: _darkModeKey, value: value.toString());
  }

  Future<void> changeColor(int index) async {
    if (index < 0 || index >= AppColors.themeColors.length) return;

    state = state.copyWith(colorIndex: index);

    await _storage.write(key: _colorIndexKey, value: index.toString());
  }
}

final themeProvider = NotifierProvider<ThemeController, ThemeSettings>(
  ThemeController.new,
);
