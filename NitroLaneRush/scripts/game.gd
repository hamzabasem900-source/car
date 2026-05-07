extends Node2D

# Game Manager Script - Nitro Lane Rush
# Controls all gameplay systems: score, distance, lives, nitro, difficulty, spawning

# ── Exports (tunable from Inspector) ─────────────────────────────────────────
@export var max_distance: float = 3000.0       # Distance to win (meters)
@export var base_road_speed: float = 250.0     # Starting scroll speed
@export var max_road_speed: float = 600.0      # Maximum scroll speed
@export var speed_increase_rate: float = 8.0   # Speed gain per second
@export var max_lives: int = 3
@export var max_nitro: float = 100.0
@export var nitro_drain_rate: float = 20.0     # Per second when active
@export var nitro_boost_multiplier: float = 1.7
@export var enemy_spawn_interval: float = 2.0
@export var nitro_spawn_interval: float = 5.0
@export var lane_positions: Array[float] = [120.0, 240.0, 360.0]

# ── Node References ───────────────────────────────────────────────────────────
@onready var player: Area2D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var road_tile_1: ColorRect = $RoadContainer/RoadTile1
@onready var road_tile_2: ColorRect = $RoadContainer/RoadTile2
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var nitro_spawn_timer: Timer = $NitroSpawnTimer
@onready var gameplay_music: AudioStreamPlayer = $GameplayMusic
@onready var win_sfx: AudioStreamPlayer = $WinSFX
@onready var lose_sfx: AudioStreamPlayer = $LoseSFX
@onready var camera: Camera2D = $Camera2D
@onready var enemies_container: Node2D = $EnemiesContainer
@onready var pickups_container: Node2D = $PickupsContainer
@onready var progress_bar: ProgressBar = $HUD/ProgressBar

# ── State Variables ───────────────────────────────────────────────────────────
var score: int = 0
var distance: float = 0.0
var lives: int = 3
var nitro: float = 0.0
var current_road_speed: float = 0.0
var is_nitro_active: bool = false
var game_active: bool = false
var road_scroll_y: float = 0.0
var road_height: float = 854.0
var screen_shake_amount: float = 0.0
var original_camera_pos: Vector2
var score_accumulator: float = 0.0

# Track recently used lanes to prevent unfair spawning
var lane_last_spawn_time: Array[float] = [0.0, 0.0, 0.0]
var min_lane_gap: float = 1.0  # Minimum seconds between spawns in same lane

# ── Preloads ─────────────────────────────────────────────────────────────────
var enemy_scene: PackedScene = preload("res://scenes/EnemyCar.tscn")
var nitro_pickup_scene: PackedScene = preload("res://scenes/NitroPickup.tscn")

func _ready() -> void:
	lives = max_lives
	current_road_speed = base_road_speed
	game_active = true

	if camera:
		original_camera_pos = camera.position

	# Connect player signals
	if player:
		player.life_lost.connect(_on_player_life_lost)
		player.player_died.connect(_on_player_died)
		player.nitro_collected.connect(_on_nitro_collected)

	# Connect spawn timers
	enemy_spawn_timer.wait_time = enemy_spawn_interval
	enemy_spawn_timer.timeout.connect(_spawn_enemy)
	enemy_spawn_timer.start()

	nitro_spawn_timer.wait_time = nitro_spawn_interval
	nitro_spawn_timer.timeout.connect(_spawn_nitro_pickup)
	nitro_spawn_timer.start()

	# Start music
	if gameplay_music and gameplay_music.stream:
		gameplay_music.play()

	# Initial HUD update
	_update_hud()

func _process(delta: float) -> void:
	if not game_active:
		return

	_scroll_road(delta)
	_update_speed(delta)
	_update_distance(delta)
	_handle_nitro_input(delta)
	_update_score(delta)
	_update_difficulty()
	_handle_screen_shake(delta)
	_update_hud()
	_check_win_condition()

# ── Road Scrolling ────────────────────────────────────────────────────────────
func _scroll_road(delta: float) -> void:
	var speed = current_road_speed * _get_nitro_multiplier()
	road_scroll_y += speed * delta

	# Two-tile seamless scroll
	if road_tile_1 and road_tile_2:
		var h = road_height
		road_tile_1.position.y = fmod(road_scroll_y, h)
		road_tile_2.position.y = fmod(road_scroll_y, h) - h

	# Update all enemies with current road speed
	if enemies_container:
		for enemy in enemies_container.get_children():
			if enemy.has_method("update_road_speed"):
				enemy.update_road_speed(speed)

func _get_nitro_multiplier() -> float:
	if is_nitro_active:
		return nitro_boost_multiplier
	return 1.0

# ── Speed System ──────────────────────────────────────────────────────────────
func _update_speed(delta: float) -> void:
	current_road_speed = min(current_road_speed + speed_increase_rate * delta, max_road_speed)

# ── Distance & Score ──────────────────────────────────────────────────────────
func _update_distance(delta: float) -> void:
	var effective_speed = current_road_speed * _get_nitro_multiplier()
	distance += (effective_speed / 100.0) * delta  # Convert to meters

func _update_score(delta: float) -> void:
	var rate = 10.0 * _get_nitro_multiplier()
	score_accumulator += rate * delta * (current_road_speed / base_road_speed)
	var points_to_add := int(score_accumulator)
	if points_to_add > 0:
		score += points_to_add
		score_accumulator -= float(points_to_add)

# ── Nitro System ──────────────────────────────────────────────────────────────
func _handle_nitro_input(delta: float) -> void:
	if Input.is_action_just_pressed("use_nitro") and nitro > 5.0:
		if not is_nitro_active:
			is_nitro_active = true
			if player and player.has_method("activate_nitro"):
				player.activate_nitro()
			if hud and hud.has_method("show_nitro_activate"):
				hud.show_nitro_activate()

	if is_nitro_active:
		nitro -= nitro_drain_rate * delta
		if nitro <= 0.0:
			nitro = 0.0
			is_nitro_active = false
			if player and player.has_method("deactivate_nitro"):
				player.deactivate_nitro()

	nitro = clampf(nitro, 0.0, max_nitro)

func _on_nitro_collected(amount: float) -> void:
	nitro = min(nitro + amount, max_nitro)

# ── Spawning ──────────────────────────────────────────────────────────────────
func _spawn_enemy() -> void:
	if not game_active or not enemy_scene:
		return

	# Pick a fair lane
	var available_lanes: Array[int] = []
	var current_time = Time.get_ticks_msec() / 1000.0
	for i in range(3):
		if current_time - lane_last_spawn_time[i] >= min_lane_gap:
			available_lanes.append(i)

	if available_lanes.is_empty():
		return

	var chosen_lane = available_lanes[randi() % available_lanes.size()]
	lane_last_spawn_time[chosen_lane] = current_time

	var enemy = enemy_scene.instantiate()

	# Pick random enemy type weighted by difficulty before adding the node, so _ready()
	# initializes speed and visuals from the selected type.
	var difficulty_factor = distance / max_distance
	var type_roll = randf()
	var enemy_type = 0  # SLOW_CAR default
	if type_roll < 0.2 + difficulty_factor * 0.2:
		enemy_type = 3  # OBSTACLE
	elif type_roll < 0.4 + difficulty_factor * 0.15:
		enemy_type = 1  # FAST_CAR
	elif type_roll < 0.55:
		enemy_type = 2  # TRUCK

	enemy.enemy_type = enemy_type
	enemy.base_speed = 150.0 + difficulty_factor * 150.0

	var spawn_x = lane_positions[chosen_lane]
	enemy.position = Vector2(spawn_x, -80.0)

	if enemy.has_method("setup"):
		enemy.setup(chosen_lane, current_road_speed)

	enemies_container.add_child(enemy)

func _spawn_nitro_pickup() -> void:
	if not game_active or not nitro_pickup_scene:
		return

	var lane = randi() % 3
	var pickup = nitro_pickup_scene.instantiate()
	pickups_container.add_child(pickup)
	pickup.position = Vector2(lane_positions[lane], -60.0)
	pickup.road_speed = current_road_speed

# ── Difficulty ────────────────────────────────────────────────────────────────
func _update_difficulty() -> void:
	var difficulty = distance / max_distance
	# Reduce spawn interval as difficulty increases
	var new_interval = max(0.8, enemy_spawn_interval - difficulty * 1.2)
	if abs(enemy_spawn_timer.wait_time - new_interval) > 0.1:
		enemy_spawn_timer.wait_time = new_interval

# ── Player Damage ─────────────────────────────────────────────────────────────
func _on_player_life_lost() -> void:
	lives -= 1

	# Screen shake
	screen_shake_amount = 12.0

	# HUD damage flash
	if hud and hud.has_method("show_damage_flash"):
		hud.show_damage_flash()

	if lives <= 0:
		_trigger_game_over()

func _on_player_died() -> void:
	_trigger_game_over()

# ── Screen Shake ──────────────────────────────────────────────────────────────
func _handle_screen_shake(delta: float) -> void:
	if screen_shake_amount > 0:
		var shake_x = randf_range(-screen_shake_amount, screen_shake_amount)
		var shake_y = randf_range(-screen_shake_amount, screen_shake_amount)
		if camera:
			camera.position = original_camera_pos + Vector2(shake_x, shake_y)
		screen_shake_amount = move_toward(screen_shake_amount, 0.0, 40.0 * delta)
	else:
		if camera:
			camera.position = original_camera_pos

# ── Win / Lose ────────────────────────────────────────────────────────────────
func _check_win_condition() -> void:
	if distance >= max_distance:
		_trigger_win()

func _trigger_win() -> void:
	game_active = false
	enemy_spawn_timer.stop()
	nitro_spawn_timer.stop()
	if gameplay_music:
		gameplay_music.stop()
	if win_sfx and win_sfx.stream:
		win_sfx.play()
	# Save score and navigate
	GameData.final_score = score
	GameData.final_distance = int(distance)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/WinScreen.tscn")

func _trigger_game_over() -> void:
	game_active = false
	enemy_spawn_timer.stop()
	nitro_spawn_timer.stop()
	if gameplay_music:
		gameplay_music.stop()
	if lose_sfx and lose_sfx.stream:
		lose_sfx.play()
	GameData.final_score = score
	GameData.final_distance = int(distance)
	await get_tree().create_timer(1.2).timeout
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

# ── HUD Update ────────────────────────────────────────────────────────────────
func _update_hud() -> void:
	if not hud:
		return
	if hud.has_method("update_score"):
		hud.update_score(score)
	if hud.has_method("update_distance"):
		hud.update_distance(distance, max_distance)
	if hud.has_method("update_speed"):
		var display_speed = (current_road_speed / base_road_speed) * 80.0
		if is_nitro_active:
			display_speed *= nitro_boost_multiplier
		hud.update_speed(display_speed)
	if hud.has_method("update_lives"):
		hud.update_lives(lives)
	if hud.has_method("update_nitro"):
		hud.update_nitro(nitro, max_nitro)
	if progress_bar:
		progress_bar.max_value = max_distance
		progress_bar.value = clampf(distance, 0.0, max_distance)
