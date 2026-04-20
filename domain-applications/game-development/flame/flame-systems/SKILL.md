---
name: flame-systems
description: Flame Engine 14 game systems - quest, dialogue, inventory, combat, save/load, shop, crafting, and more
domain: game-development
version: 2.0.0
tags: [flame, flutter, dart, game-systems, rpg]
---

# Flame Game Systems

Implementation patterns and reference snippets for 14 common game systems.

## Reference index

| System | File | Description |
|--------|------|-------------|
| **Quest** | `references/quest.md` | Objectives, tracking, rewards |
| **Dialogue** | `references/dialogue.md` | Branching dialogue, NPCs |
| **Localization** | `references/localization.md` | Strings and locales |
| **Inventory** | `references/inventory.md` | Items, stacking, categories |
| **Paper Doll** | `references/paperdoll.md` | Equipment visuals |
| **Combat** | `references/combat.md` | Combat flow, damage |
| **Skills** | `references/skills.md` | Skill trees, cooldowns, effects |
| **Save/Load** | `references/saveload.md` | Serialization, cloud saves |
| **Achievement** | `references/achievement.md` | Achievements and progress |
| **Shop** | `references/shop.md` | Buying, selling, currency |
| **Crafting** | `references/crafting.md` | Recipes and materials |
| **Procedural** | `references/procedural.md` | PCG, roguelike maps |
| **Multiplayer** | `references/multiplayer.md` | Networking, sync |
| **Level Editor** | `references/leveleditor.md` | Authoring tools |

## AI usage guide

```
Quests?        → Read references/quest.md
Dialogue?      → Read references/dialogue.md
Localization? → Read references/localization.md
Inventory?     → Read references/inventory.md
Paper doll?    → Read references/paperdoll.md
Combat?        → Read references/combat.md
Skills?        → Read references/skills.md
Save/load?     → Read references/saveload.md
Achievements?  → Read references/achievement.md
Shop?          → Read references/shop.md
Crafting?      → Read references/crafting.md
Procedural?    → Read references/procedural.md
Multiplayer?   → Read references/multiplayer.md
Level editor?  → Read references/leveleditor.md
```

## System dependencies

```
Combat ──→ Skills (skills affect combat)
       ──→ Inventory (gear affects stats)
       ──→ Paper Doll (gear visuals)

Quest ──→ Dialogue (NPCs grant quests)
      ──→ Achievement (quest completion)
      ──→ Inventory (quest rewards)

Shop ──→ Inventory (purchases go to inventory)
     ──→ Crafting (buy materials)

Procedural ──→ Combat (spawn enemies)
           ──→ Inventory (random drops)
```

## Related skills

- `flame-core` — Engine fundamentals
- `flame-templates` — Genre templates
