# Assets - Nitro Lane Rush

## Folder Structure

### res://assets/cars/
- player_car.png         → Blue sports car (Top-Down view, facing up)
                           Recommended size: 64x100 px
- enemy_cars.png         → Sprite sheet or individual enemy car images
- slow_car.png           → Standard traffic car (orange/gray)
- fast_car.png           → Fast car (red)
- truck.png              → Large truck
- obstacle.png           → Road cones or barriers

### res://assets/road/
- road_tile.png          → Night road with 3 lanes
                           Should tile vertically (seamless)
                           Recommended size: 320x854 px or any tileable height
                           Lane dividers already built in the scene with ColorRects
                           (Can replace with your texture)

### res://assets/backgrounds/
- city_night.png         → Cyberpunk city background for menu/sides

### res://assets/ui/
- hud_reference.png      → HUD reference image (for design inspiration)

## How to Connect Your Assets

### In Godot Editor:

1. **Player Car:**
   - Open scenes/Game.tscn
   - Select Player > Sprite2D
   - Set Texture to your player_car.png
   - Remove the ColorRect children used as placeholder

2. **Enemy Cars:**
   - Open scenes/EnemyCar.tscn
   - Select Sprite2D
   - Set Texture to your car image
   - Adjust CollisionShape2D to match sprite size

3. **Road:**
   - Open scenes/Game.tscn
   - Select RoadContainer > RoadTile1 and RoadTile2
   - Change node type from ColorRect to TextureRect if needed
   - Set your road texture

4. **Background City:**
   - Open scenes/MainMenu.tscn
   - Select CityBackground node
   - Add your city_night.png as texture

5. **Audio:**
   - Select each AudioStreamPlayer node
   - Assign the corresponding audio file from res://audio/

## Recommended Sprite Settings
- Import all sprites with: Filter = Nearest (for pixel art) or Linear (for smooth)
- For the road: enable Repeat in import settings
- Set player sprite rotation_degrees = 0 (car should face upward/north)
