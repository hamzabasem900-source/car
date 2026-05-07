extends CanvasLayer

# HUD Script - Nitro Lane Rush
# Manages all heads-up display elements

@onready var score_label: Label = $HUDPanel/ScoreLabel
@onready var distance_label: Label = $HUDPanel/DistanceLabel
@onready var speed_label: Label = $HUDPanel/SpeedLabel
@onready var lives_container: HBoxContainer = $HUDPanel/LivesContainer
@onready var nitro_bar: ProgressBar = $HUDPanel/NitroBar
@onready var nitro_glow: ColorRect = $NitroGlow
@onready var flash_overlay: ColorRect = $FlashOverlay
@onready var nitro_active_label: Label = $HUDPanel/NitroActiveLabel
@onready var objective_label: Label = $HUDPanel/ObjectiveLabel

var flash_tween: Tween = null
var nitro_glow_tween: Tween = null

func _ready() -> void:
	# Initialize flash overlay
	if flash_overlay:
		flash_overlay.color = Color(1, 0, 0, 0)
	
	if nitro_glow:
		nitro_glow.color = Color(0, 0.5, 1.0, 0)
	
	if nitro_active_label:
		nitro_active_label.visible = false

func update_score(score: int) -> void:
	if score_label:
		score_label.text = "SCORE\n%07d" % score

func update_distance(distance: float, max_distance: float) -> void:
	if distance_label:
		distance_label.text = "DIST\n%dm/%dm" % [int(distance), int(max_distance)]
	if objective_label:
		var meters_left := max(0, int(ceil(max_distance - distance)))
		objective_label.text = "GOAL: REACH %dm TO WIN  •  %dm LEFT" % [int(max_distance), meters_left]

func update_speed(speed: float) -> void:
	if speed_label:
		speed_label.text = "SPD\n%dkm/h" % int(speed)

func update_lives(lives: int) -> void:
	if not lives_container:
		return
	# Clear existing hearts
	for child in lives_container.get_children():
		child.queue_free()
	# Add heart icons
	for i in range(lives):
		var heart = Label.new()
		heart.text = "❤"
		heart.add_theme_color_override("font_color", Color(1.0, 0.2, 0.4))
		heart.add_theme_font_size_override("font_size", 24)
		lives_container.add_child(heart)

func update_nitro(nitro: float, max_nitro: float) -> void:
	if nitro_bar:
		nitro_bar.max_value = max_nitro
		nitro_bar.value = nitro

func show_damage_flash() -> void:
	if not flash_overlay:
		return
	if flash_tween:
		flash_tween.kill()
	flash_overlay.color = Color(1, 0, 0, 0.4)
	flash_tween = create_tween()
	flash_tween.tween_property(flash_overlay, "color", Color(1, 0, 0, 0), 0.5)

func show_nitro_activate() -> void:
	# Blue glow flash when nitro activates
	if nitro_glow:
		if nitro_glow_tween:
			nitro_glow_tween.kill()
		nitro_glow.color = Color(0, 0.7, 1.0, 0.35)
		nitro_glow_tween = create_tween()
		nitro_glow_tween.tween_property(nitro_glow, "color", Color(0, 0.7, 1.0, 0), 0.6)
	
	if nitro_active_label:
		nitro_active_label.visible = true
		await get_tree().create_timer(1.0).timeout
		nitro_active_label.visible = false
