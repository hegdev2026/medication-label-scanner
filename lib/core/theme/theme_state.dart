part of 'theme_cubit.dart';

@immutable
class ThemeState extends Equatable {
  const ThemeState({required this.mode, required this.platformBrightness});

  final ThemeMode mode;

  /// OS setting, tracked so [ThemeMode.system] follows it.
  final Brightness platformBrightness;

  Brightness get brightness => switch (mode) {
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
    ThemeMode.system => platformBrightness,
  };

  bool get isDark => brightness == Brightness.dark;
  AppPalette get palette => isDark ? AppPalette.dark : AppPalette.light;

  ThemeState copyWith({ThemeMode? mode, Brightness? platformBrightness}) =>
      ThemeState(
        mode: mode ?? this.mode,
        platformBrightness: platformBrightness ?? this.platformBrightness,
      );

  @override
  List<Object?> get props => [mode, platformBrightness];
}
