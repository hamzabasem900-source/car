extends Node

# Main Menu Script - Nitro Lane Rush
# Handles main menu UI and navigation

@onready var start_button: Button = $UI/VBoxContainer/StartButton
@onready var instructions_button: Button = $UI/VBoxContainer/InstructionsButton
@onready var exit_button: Button = $UI/VBoxContainer/ExitButton
@onready var lobby_music: AudioStreamPlayer = $LobbyMusic
@onready var button_sfx: AudioStreamPlayer = $ButtonSFX
@onready var road_scroll: TextureRect = $RoadScroll
@onready var city_bg: TextureRect = $CityBackground
@onready var title_label: Label = $UI/TitleLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var scroll_speed: float = 100.0
var road_offset: float = 0.0

func _ready() -> void:
	# Connect button signals
	start_button.pressed.connect(_on_start_pressed)
	instructions_button.pressed.connect(_on_instructions_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	
	# Play lobby music
	if lobby_music and lobby_music.stream:
		lobby_music.play()
	
	# Animate title
	if animation_player:
		animation_player.play("intro")

func _process(delta: float) -> void:
	# Scroll road background for visual effect
	if road_scroll:
		road_offset += scroll_speed * delta
		road_scroll.position.y = fmod(road_offset, road_scroll.texture.get_height() if road_scroll.texture else 854.0)

func _play_button_sound() -> void:
	if button_sfx and button_sfx.stream:
		button_sfx.play()

func _on_start_pressed() -> void:
	_play_button_sound()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_instructions_pressed() -> void:
	_play_button_sound()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/Instructions.tscn")

func _on_exit_pressed() -> void:
	_play_button_sound()
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()
