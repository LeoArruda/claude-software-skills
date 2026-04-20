---
name: flame-core
description: Flame Engine core fundamentals - components, input, collision, camera, animation, scenes
domain: game-development
version: 2.0.0
tags: [flame, flutter, dart, 2d-games, game-engine]
---

# Flame Core Fundamentals

Core Flame topics: components, input, collision, camera, animation, and scene management.

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
  }
}
```

## Reference index

| Topic | File | Description |
|-------|------|-------------|
| **Components** | `references/components.md` | Lifecycle, types, best practices |
| **Input** | `references/input.md` | Touch, keyboard, gamepad |
| **Collision** | `references/collision.md` | Hitboxes and collision types |
| **Camera** | `references/camera.md` | Follow camera, HUD, viewport |
| **Animation** | `references/animation.md` | Sprite animation, effects |
| **Scenes** | `references/scenes.md` | RouterComponent, overlays, UI |
| **Audio** | `references/audio.md` | SFX, music, AudioPool |
| **Particles** | `references/particles.md` | Particle systems and VFX |
| **Performance** | `references/performance.md` | Optimization and pitfalls |
| **Debug** | `references/debug.md` | Debug mode, logging, profiling |

## AI usage guide

```
Components?     → Read references/components.md
Input?          → Read references/input.md
Collision?      → Read references/collision.md
Camera?         → Read references/camera.md
Animation?      → Read references/animation.md
Scenes / UI?    → Read references/scenes.md
Audio?          → Read references/audio.md
Particles?      → Read references/particles.md
Performance?    → Read references/performance.md
Debug / logs?   → Read references/debug.md
```

## Component types quick reference

| Type | Use case |
|------|----------|
| `Component` | Logic only |
| `PositionComponent` | Has position/size |
| `SpriteComponent` | Static image |
| `SpriteAnimationComponent` | Animated sprite |
| `SpriteAnimationGroupComponent` | Multiple animation states |

## Related skills

- `flame-systems` — 14 gameplay systems (quests, dialogue, inventory, etc.)
- `flame-templates` — RPG, platformer, and roguelike starters
