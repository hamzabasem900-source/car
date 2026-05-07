extends Area2D

# Enemy Car / Obstacle Script - Nitro Lane Rush
# Handles movement and behavior of traffic cars and obstacles

enum EnemyType {SLOW_CAR, FAST_CAR, TRUCK, OBSTACLE}

@export var enemy_type: EnemyType = EnemyType.SLOW_CAR
@export var base_speed: float = 200.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var speed: float = 0.0
var road_speed: float = 0.0  # Receives current road scroll speed from game manager
var lane: int = 0

# Speed multipliers per type
const SPEED_MULTIPLIERS: Dictionary = {
	EnemyType.SLOW_CAR: 0.6,
	EnemyType.FAST_CAR: 1.4,
	EnemyType.TRUCK: 0.5,
	EnemyType.OBSTACLE: 0.0  # Obstacles don't move on their own
}

# Color tints per type for visual differentiation
const TYPE_COLORS: Dictionary = {
	EnemyType.SLOW_CAR: Color(1.0, 0.6, 0.0),   # Orange
	EnemyType.FAST_CAR: Color(1.0, 0.2, 0.2),    # Red
	EnemyType.TRUCK: Color(0.4, 0.4, 0.8),        # Blue-gray
	EnemyType.OBSTACLE: Color(1.0, 0.8, 0.0)      # Yellow
}

func _ready() -> void:
	add_to_group("enemy")
	speed = base_speed * SPEED_MULTIPLIERS[enemy_type]
	
	# Apply color tint to sprite
	if sprite:
		sprite.modulate = TYPE_COLORS.get(enemy_type, Color.WHITE)

func setup(p_lane: int, p_road_speed: float) -> void:
	lane = p_lane
	road_speed = p_road_speed

func _process(delta: float) -> void:
	# Move downward: own speed + road scroll speed
	position.y += (speed + road_speed) * delta
	
	# Remove when off screen
	if position.y > 1000.0:
		queue_free()

func update_road_speed(new_speed: float) -> void:
	road_speed = new_speed
