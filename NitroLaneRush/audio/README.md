# Audio Files - Nitro Lane Rush

Place your audio files in this folder: `res://audio/`.

## Required file names

Use these exact names so it is easy to assign them to the matching `AudioStreamPlayer` nodes:

| File name | Used for | Scene / node to assign it to |
|---|---|---|
| `lobby_music.ogg` | Main menu / lobby background music | `scenes/MainMenu.tscn` → `LobbyMusic` |
| `gameplay_music.ogg` | Race background music | `scenes/Game.tscn` → `GameplayMusic` |
| `engine_loop.ogg` | Player engine loop | `scenes/Game.tscn` → `Player/EngineSFX` and/or `scenes/Player.tscn` → `EngineSFX` |
| `crash.wav` | Collision / crash sound | `scenes/Game.tscn` → `Player/CrashSFX` and/or `scenes/Player.tscn` → `CrashSFX` |
| `lose.wav` | Game-over / loss sound | `scenes/Game.tscn` → `LoseSFX` |
| `win.wav` | Victory sound | `scenes/Game.tscn` → `WinSFX` |
| `nitro.wav` | Nitro activation sound | `scenes/Game.tscn` → `Player/NitroSFX` and/or `scenes/Player.tscn` → `NitroSFX` |
| `collect.wav` | Nitro pickup collection sound | `scenes/NitroPickup.tscn` → `CollectSFX` |
| `button_click.wav` | UI button clicks | `ButtonSFX` nodes in `MainMenu`, `Instructions`, `GameOver`, and `WinScreen` |

## How to add the sounds in Godot

1. Copy the audio files into `NitroLaneRush/audio/`.
2. Open the project in Godot.
3. Wait for Godot to import the new files.
4. Open the scene listed in the table above.
5. Select the matching `AudioStreamPlayer` node.
6. In the Inspector, drag the audio file from `res://audio/` into the node's **Stream** property.
7. Save the scene.
8. Repeat for each sound.

## Loop settings

Enable looping for long ambience/music files:

- `lobby_music.ogg`
- `gameplay_music.ogg`
- `engine_loop.ogg`

In Godot, select the audio file in the FileSystem dock, open the **Import** tab, enable loop if available for that format, then click **Reimport**.

## Suggested volume levels

- Music (`LobbyMusic`, `GameplayMusic`): around `-5 dB` to `-8 dB`.
- Engine (`EngineSFX`): around `-10 dB` to `-14 dB`.
- Effects (`CrashSFX`, `NitroSFX`, `WinSFX`, `LoseSFX`, `CollectSFX`): around `0 dB` to `-3 dB`.

## Arabic quick guide

ضع الملفات داخل `res://audio/` بنفس الأسماء في الجدول، ثم افتح المشهد، اختر عقدة الصوت المناسبة، واسحب الملف إلى خاصية **Stream** من الـ Inspector. أصوات اللوبي والسباق والمحرك يجب أن تكون Loop، أما التصادم والفوز والخسارة والنيترو فهي مؤثرات قصيرة بدون Loop.
