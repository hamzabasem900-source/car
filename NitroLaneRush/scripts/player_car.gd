extends Area2D

# Player Car Script - Nitro Lane Rush
# Handles player movement, collision, nitro, and visual effects

signal life_lost
signal nitro_collected(amount: float)
signal player_died

# Lane positions (X coordinates for 3 lanes)
@export var lane_positions: Array[float] = [120.0, 240.0, 360.0]
@export var lane_switch_speed: float = 8.0  # Speed of lane transition
@export var invincibility_duration: float = 1.5  # Seconds of invincibility after hit

# References
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var nitro_particles: GPUParticles2D = $NitroParticles
@onready var crash_sfx: AudioStreamPlayer = $CrashSFX
@onready var nitro_sfx: AudioStreamPlayer = $NitroSFX
@onready var engine_sfx: AudioStreamPlayer = $EngineSFX
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var flash_timer: Timer = $FlashTimer

# State variables
var current_lane: int = 1  # 0=left, 1=center, 2=right
var target_x: float = 0.0
var is_invincible: bool = false
var is_alive: bool = true
var flash_state: bool = false

func _ready() -> void:
	# Start in center lane
	current_lane = 1
	target_x = lane_positions[current_lane]
	position.x = target_x
	
	# Connect timers
	invincibility_timer.timeout.connect(_on_invincibility_end)
	flash_timer.timeout.connect(_on_flash_tick)
	
	# Connect collision signal
	area_entered.connect(_on_area_entered)
	
	# Start engine sound
	if engine_sfx and engine_sfx.stream:
		engine_sfx.play()

func _process(delta: float) -> void:
	if not is_alive:
		return
	
	_handle_input()
	_smooth_lane_movement(delta)

func _handle_input() -> void:
	# Move left
	if Input.is_action_just_pressed("move_left"):
		if current_lane > 0:
			current_lane -= 1
			target_x = lane_positions[current_lane]
	
	# Move right
	if Input.is_action_just_pressed("move_right"):
		if current_lane < 2:
			current_lane += 1
			target_x = lane_positions[current_lane]

func _smooth_lane_movement(delta: float) -> void:
	# Smoothly interpolate to target lane X position
	position.x = lerp(position.x, target_x, lane_switch_speed * delta)

func take_damage() -> void:
	if is_invincible or not is_alive:
		return
	
	# Play crash sound
	if crash_sfx and crash_sfx.stream:
		crash_sfx.play()
	
	# Emit signal to game manager
	life_lost.emit()
	
	# Start invincibility period
	is_invincible = true
	invincibility_timer.start(invincibility_duration)
	flash_timer.start(0.1)
	
	# Screen shake (handled by game manager via signal)

func _on_invincibility_end() -> void:
	is_invincible = false
	flash_timer.stop()
	if sprite:
		sprite.modulate.a = 1.0
		sprite.modulate = Color.WHITE

func _on_flash_tick() -> void:
	# Flash effect during invincibility
	flash_state = !flash_state
	if sprite:
		sprite.modulate = Color(1.0, 0.3, 0.3, 1.0) if flash_state else Color.WHITE

func activate_nitro() -> void:
	# Visual nitro effect
	if nitro_particles:
		nitro_particles.emitting = true
	if nitro_sfx and nitro_sfx.stream:
		nitro_sfx.play()

func deactivate_nitro() -> void:
	if nitro_particles:
		nitro_particles.emitting = false

func collect_nitro_pickup(amount: float) -> void:
	nitro_collected.emit(amount)

func die() -> void:
	is_alive = false
	player_died.emit()
	# Death animation could go here
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		take_damage()
	elif area.is_in_group("nitro_pickup"):
		collect_nitro_pickup(25.0)
		area.collect()
