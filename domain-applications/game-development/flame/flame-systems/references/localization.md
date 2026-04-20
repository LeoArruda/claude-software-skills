# Localization System Reference

## Data structure

```dart
class LocalizationManager {
  String _currentLocale = 'en';
  final Map<String, Map<String, String>> _translations = {};

  String get currentLocale => _currentLocale;
  List<String> get availableLocales => _translations.keys.toList();

  void loadTranslations(String locale, Map<String, String> strings) {
    _translations[locale] = strings;
  }

  void setLocale(String locale) {
    if (_translations.containsKey(locale)) {
      _currentLocale = locale;
      onLocaleChanged?.call(locale);
    }
  }

  String tr(String key, [Map<String, dynamic>? params]) {
    final text = _translations[_currentLocale]?[key] ?? key;

    if (params == null) return text;

    // Replace placeholders: {name}, {count}
    return text.replaceAllMapped(
      RegExp(r'\{(\w+)\}'),
      (match) => params[match.group(1)]?.toString() ?? match.group(0)!,
    );
  }

  void Function(String)? onLocaleChanged;
}

// Global accessor
late LocalizationManager l10n;
```

## JSON translation files

```json
// assets/i18n/en.json
{
  "game_title": "Epic Adventure",
  "menu_start": "Start Game",
  "menu_settings": "Settings",
  "menu_quit": "Quit",
  "dialog_hello": "Hello, {name}!",
  "quest_kill": "Kill {count} {enemy}",
  "item_gold": "{amount} Gold",
  "achievement_unlocked": "Achievement Unlocked: {title}"
}

// assets/i18n/es.json
{
  "game_title": "Aventura épica",
  "menu_start": "Comenzar",
  "menu_settings": "Ajustes",
  "menu_quit": "Salir",
  "dialog_hello": "Hola, {name}!",
  "quest_kill": "Elimina {count} {enemy}",
  "item_gold": "{amount} oro",
  "achievement_unlocked": "Logro desbloqueado: {title}"
}
```

## Loading translations

```dart
class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    l10n = LocalizationManager();

    // Load from JSON
    final enJson = await rootBundle.loadString('assets/i18n/en.json');
    final esJson = await rootBundle.loadString('assets/i18n/es.json');

    l10n.loadTranslations('en', Map<String, String>.from(jsonDecode(enJson)));
    l10n.loadTranslations('es', Map<String, String>.from(jsonDecode(esJson)));

    // Set default or saved preference
    final savedLocale = prefs.getString('locale') ?? 'en';
    l10n.setLocale(savedLocale);
  }
}
```

## Usage in game

```dart
// Simple text
final title = l10n.tr('game_title');  // English or Spanish string per locale

// With parameters
final greeting = l10n.tr('dialog_hello', {'name': 'Hero'});
// Locale-specific greeting with the hero name

final questText = l10n.tr('quest_kill', {'count': 5, 'enemy': 'Rats'});
// "Kill 5 Rats" / Spanish equivalent depending on locale

// In components
class MenuButton extends TextComponent {
  final String textKey;

  @override
  Future<void> onLoad() async {
    text = l10n.tr(textKey);

    l10n.onLocaleChanged = (_) {
      text = l10n.tr(textKey);
    };
  }
}
```

## Pluralization

```dart
extension LocalizationExtension on LocalizationManager {
  String plural(String key, int count, {Map<String, dynamic>? params}) {
    final pluralKey = count == 1 ? '${key}_one' : '${key}_other';
    final finalParams = {...?params, 'count': count};
    return tr(pluralKey, finalParams);
  }
}

// JSON
{
  "enemy_killed_one": "Killed 1 enemy",
  "enemy_killed_other": "Killed {count} enemies"
}

// Usage
l10n.plural('enemy_killed', 1);  // "Killed 1 enemy"
l10n.plural('enemy_killed', 5);  // "Killed 5 enemies"
```

## Language selector UI

```dart
class LanguageSelector extends PositionComponent with TapCallbacks {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
  ];

  @override
  void render(Canvas canvas) {
    double y = 0;
    for (final lang in languages) {
      final isSelected = lang['code'] == l10n.currentLocale;
      _drawText(
        canvas,
        '${isSelected ? "► " : "  "}${lang['name']}',
        Vector2(0, y),
      );
      y += 30;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    final index = (event.localPosition.y / 30).floor();
    if (index < languages.length) {
      l10n.setLocale(languages[index]['code']!);
    }
  }
}
```

## Font support

```dart
// For CJK, use a font that includes those glyphs
final cjkRenderer = TextPaint(
  style: const TextStyle(
    fontFamily: 'NotoSansTC',
    fontSize: 16,
  ),
);

// Load in pubspec.yaml
// fonts:
//   - family: NotoSansTC
//     fonts:
//       - asset: assets/fonts/NotoSansTC-Regular.otf
```
