---
schema: "1.0"
name: flame-game-dev
version: "2.2.0"
description: Complete Flame Engine 2D game development guide - core, systems, templates, shipping
domain: game-development
triggers:
  keywords:
    primary: [flame, flame engine, flutter game, 2d game flutter, FlameGame]
    secondary: [SpriteComponent, SpriteAnimationComponent, collision detection flutter, flame_audio, flame_tiled]
  context_boost: [flutter, dart, mobile game, cross-platform game, hyper-casual, platformer, roguelike]
  context_penalty: [unity, godot, unreal, 3d game]
  priority: high
dependencies:
  prerequisites: [flutter, dart]
  related: [game-design, mobile]
author: leoarruda
---

# Flame Engine 2D Game Development

Guide to Flame: core concepts, 14 gameplay systems, and three genre templates.

## Sub-skills index

| Skill | Description | References |
|-------|-------------|------------|
| **flame-core** | Engine fundamentals | 10 files |
| **flame-systems** | Gameplay systems | 14 files |
| **flame-templates** | Genre starters | 3 files |

## Quick navigation

### flame-core
```
components.md   - Component lifecycle and types
input.md        - Touch, keyboard, gamepad
collision.md    - Hitboxes and collision
camera.md       - Camera, HUD, viewport
animation.md    - Sprite animation, effects
scenes.md       - RouterComponent, overlays, UI
audio.md        - SFX and music
particles.md    - Particles and VFX
performance.md  - Optimization
debug.md        - Debugging and logging
```

### flame-systems
```
quest.md        - Quests          achievement.md - Achievements
dialogue.md     - Dialogue       shop.md        - Shops
localization.md - Localization   crafting.md    - Crafting
inventory.md    - Inventory      procedural.md  - Procedural
paperdoll.md    - Paper doll     multiplayer.md - Multiplayer
combat.md       - Combat         leveleditor.md - Level editor
skills.md       - Skills
saveload.md     - Save/load
```

### flame-templates
```
rpg.md          - Turn-based / action RPG
platformer.md   - Side-scrolling platformer
roguelike.md    - Procedural dungeons
```

## AI usage guide

```
# Basics
New to Flame?        → Read flame-core/SKILL.md first
Need a feature?      → Use the flame-core index

# Systems
Quests / dialogue?   → flame-systems/references/quest.md or dialogue.md
Combat?              → flame-systems/references/combat.md + skills.md
Save/load?           → flame-systems/references/saveload.md
Multiplayer?         → flame-systems/references/multiplayer.md

# Full games
RPG?                 → flame-templates/references/rpg.md
Platformer?          → flame-templates/references/platformer.md
Roguelike?           → flame-templates/references/roguelike.md

# Shipping
Publishing?          → See “Deployment” below
```

## When to use Flame

From [Filip Hráček’s benchmark](https://filiph.net/text/benchmarking-flutter-flame-unity-godot.html):

### Strengths

| Topic | Flame | Unity/Godot |
|-------|-------|---------------|
| **Cold start** | Fastest | Slower |
| **Binary size** | Smaller | Larger |
| **Learning curve** | Familiar if you know Flutter | New tooling |
| **Cross-platform** | One codebase, many targets | Per-target tweaks |
| **Hot reload** | Yes | Partial |

### Limits

| Topic | Flame | Unity/Godot |
|-------|-------|-------------|
| **Max entities** | ~hundreds | Thousands |
| **3D** | No | Full |
| **Physics** | Basic (Forge2D) | Full engines |
| **Editor** | No visual editor | Full IDE |

### Recommended for Flame

- **Casual**: card, puzzle, trivia
- **Hyper-casual**: simple loops, short sessions
- **Story-driven**: visual novels, interactive fiction
- **2D platformers**: side-scrollers, Metroidvania
- **Turn-based**: tactics, RPG, board-style
- **Embedded mini-games** inside Flutter apps

### Not ideal for Flame

- **Huge entity counts**: bullet hell, RTS, massive battles
- **3D** of any kind
- **Physics-heavy**: racing, complex simulations
- **AAA** fidelity or effects

## Quick start

```bash
flutter create my_game && cd my_game
flutter pub add flame
flutter pub add flame_audio       # Optional
flutter pub add flame_tiled       # Optional
```

```dart
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() => runApp(GameWidget(game: MyGame()));

class MyGame extends FlameGame with HasCollisionDetection {
  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    // Build your game here
  }
}
```

## Deployment

Flame runs on every Flutter target:

| Platform | Channel | Command |
|----------|---------|---------|
| **iOS** | App Store | `flutter build ios --release` |
| **Android** | Google Play | `flutter build apk --release` |
| **Web** | itch.io / GitHub Pages | `flutter build web --release` |
| **macOS** | App Store / direct | `flutter build macos --release` |
| **Windows** | Steam / direct | `flutter build windows --release` |
| **Linux** | Steam / direct | `flutter build linux --release` |

### itch.io (Web)

```bash
# 1. Build web
flutter build web --release --web-renderer canvaskit

# 2. Upload the build/web folder to itch.io

# 3. itch.io settings
#    - Kind of project: HTML
#    - Embed options: Click to launch in fullscreen
```

### Google Play (Android)

```bash
# 1. Create a keystore
keytool -genkey -v -keystore ~/my-game.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-game

# 2. Configure android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=my-game
storeFile=/Users/you/my-game.jks

# 3. Build App Bundle
flutter build appbundle --release

# 4. Upload build/app/outputs/bundle/release/app-release.aab
```

### Steam (desktop)

```bash
# 1. Build desktop
flutter build windows --release  # or macos / linux

# 2. Package with Steamworks SDK
#    - Configure app_build.vdf
#    - Upload via Steam Partner

# 3. Optional: Steam achievements
#    flutter pub add steamworks
```

## Dependency graph

```
flame/ (this index)
    │
    ├── flame-core (fundamentals)
    │   └── 10 reference files
    │
    ├── flame-systems (gameplay)
    │   └── 14 reference files
    │
    └── flame-templates (starters)
        └── 3 reference files
```

## Best practices

1. **Load on demand** — open only the references you need.
2. **Learn core first** — flame-core before heavy systems.
3. **Start from templates** — add systems as required.
4. **Stay modular** — compose independent systems.

## Version history

- v2.2.0 — Added fit analysis and benchmark notes
- v2.1.0 — Audio, particles, performance, deployment
- v2.0.0 — Modular layout
- v1.0.0 — Initial release
