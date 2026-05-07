extends Area2D

# Nitro Pickup Script - Nitro Lane Rush
# Floating nitro canister that scrolls down the road

@onready var sprite: Sprite2D = $Sprite2D
@onready var collect_sfx: AudioStreamPlayer = $CollectSFX
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var road_speed: float = 200.0
var collected: bool = false

func _ready() -> void:
	add_to_group("nitro_pickup")
	# Pulsing glow animation
	if animation_player:
		animation_player.play("pulse")

func _process(delta: float) -> void:
	position.y += road_speed * delta
	
	# Destroy when off screen
	if position.y > 950.0:
		queue_free()

func collect() -> void:
	if collected:
		return
	collected = true
	if collect_sfx and collect_sfx.stream:
		collect_sfx.play()
	# Simple collect animation
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2.0, 2.0), 0.15)
	tween.tween_property(self, "modulate:a", 0.0, 0.15)
	tween.tween_callback(queue_free)
