# Nitro Lane Rush — Godot 4 Project

A cyberpunk top-down arcade racing game built with Godot 4.

---

## 🚗 Game Overview
- **Genre:** Top-Down 2D Arcade Racer
- **Style:** Cyberpunk / Neon Night City
- **Goal:** Survive 3000 meters of traffic to win
- **Lives:** 3 hearts
- **Controls:** Arrow Keys or WASD + Space for Nitro

---

## 📁 Project Structure

```
NitroLaneRush/
├── project.godot
├── scenes/
│   ├── MainMenu.tscn       ← Start screen
│   ├── Instructions.tscn   ← How to play
│   ├── Game.tscn           ← Main gameplay
│   ├── EnemyCar.tscn       ← Enemy vehicle prefab
│   ├── NitroPickup.tscn    ← Nitro canister pickup
│   ├── GameOver.tscn       ← Game over screen
│   └── WinScreen.tscn      ← Victory screen
├── scripts/
│   ├── GameData.gd         ← Autoload singleton (score/distance persistence)
│   ├── main_menu.gd
│   ├── instructions.gd
│   ├── game.gd             ← Main game manager
│   ├── player_car.gd
│   ├── enemy_car.gd
│   ├── hud.gd
│   ├── nitro_pickup.gd
│   ├── game_over.gd
│   └── win_screen.gd
├── assets/
│   ├── cars/               ← Place your car sprites here
│   ├── road/               ← Place road textures here
│   ├── backgrounds/        ← City night background
│   ├── ui/                 ← HUD graphics
│   └── README.md           ← Asset setup instructions
└── audio/
    ├── README.md           ← Audio setup instructions
    ├── lobby_music.ogg
    ├── gameplay_music.ogg
    ├── engine_loop.ogg
    ├── crash.wav
    ├── nitro.wav
    ├── collect.wav
    ├── win.wav
    ├── lose.wav
    └── button_click.wav
```

---

## 🎮 Controls
| Key | Action |
|-----|--------|
| ← / A | Move to left lane |
| → / D | Move to right lane |
| Space | Activate Nitro Boost |

---

## ⚙️ Game Systems

### Lane System
- 3 lanes at X positions: 120, 240, 360
- Smooth lerp-based transitions (not teleporting)
- Player starts in center lane (index 1)

### Scoring
- Points increase continuously with distance
- Speed multiplier increases score rate
- Nitro boost = 1.7× score multiplier

### Nitro
- Collect blue ⚡ pickups on the road
- Press Space to activate when charged
- Drains 20 units/second
- Increases road speed × 1.7 temporarily

### Lives & Damage
- 3 lives total
- 1.5 second invincibility after being hit
- Flash effect during invincibility
- Screen shake on collision
- Red screen flash on damage

### Enemy Spawning
- Timer-based spawning (adjusts with difficulty)
- 4 types: Slow Car, Fast Car, Truck, Obstacle
- Lane cooldown prevents unfair triple-spawn
- Difficulty increases every meter traveled

### Win / Lose
- Win: Reach 3000 meters
- Lose: 0 lives remaining
- Both save score to GameData singleton

---

## 🔧 Setup Steps

### 1. Open in Godot 4
- Use Godot 4.2 or newer
- Open the folder as a Godot project

### 2. Add Your Assets
- See `assets/README.md` for detailed instructions
- Place car sprites, road textures, backgrounds
- Connect them in each scene via the Inspector

### 3. Add Audio Files
- See `audio/README.md` for the required file list
- Place all .ogg and .wav files in `res://audio/`
- Enable Loop on music files in import settings
- Connect each file to its AudioStreamPlayer node

### 4. Adjust Inspector Values
In `Game.tscn` → `Game` node, you can tune:
- `max_distance` — How far to win (default: 3000)
- `base_road_speed` — Starting speed (default: 250)
- `max_road_speed` — Maximum speed (default: 600)
- `enemy_spawn_interval` — How often enemies spawn
- `nitro_boost_multiplier` — Nitro speed factor

---

## 🎨 Visual Placeholders
The game ships with colored rectangles as placeholders for all sprites.
- **Player:** Blue rectangle (replace with your car sprite)
- **Enemies:** Orange/Red/Blue rectangles by type
- **Nitro Pickup:** Cyan circle with ⚡ emoji
- **Road:** Dark gray tiles with yellow lane dividers
- **Neon Lines:** Purple/cyan edge lines

All placeholders are functional — the game is fully playable before adding real art.

---

## 🐛 Common Issues

**"Class 'GameData' not found"**
→ Make sure the Autoload is set in Project → Project Settings → Autoload
→ Name: `GameData`, Path: `res://scripts/GameData.gd`

**Audio not playing**
→ Assign audio streams to AudioStreamPlayer nodes in each scene
→ Check that Loop is enabled for music files

**Enemies not spawning**
→ Make sure `EnemyCar.tscn` is at `res://scenes/EnemyCar.tscn`
→ Check `enemy_scene` preload path in game.gd

**Player doesn't move**
→ Verify Input Map has `move_left` and `move_right` actions configured

---

Enjoy the race! 🏎️💨
