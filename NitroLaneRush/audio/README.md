# Audio Files - Nitro Lane Rush
# Place your audio files in this folder (res://audio/)

Required files:
- lobby_music.ogg        → Main menu background music (looping)
- gameplay_music.ogg     → In-game background music (looping, upbeat)
- engine_loop.ogg        → Car engine sound (looping, low volume)
- crash.wav              → Collision sound effect
- nitro.wav              → Nitro boost activation sound
- collect.wav            → Nitro pickup collection sound
- win.wav                → Level completion sound
- lose.wav               → Game over sound
- button_click.wav       → UI button click sound

Notes:
- OGG format recommended for music (smaller file size, good quality)
- WAV format for short sound effects
- All music files should have Loop enabled in Godot's import settings
- Recommended: Set engine_loop.ogg volume to around -10dB in the Player node
