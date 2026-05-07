extends Node

# Game Over Screen Script - Nitro Lane Rush

@onready var score_label: Label = $UI/Panel/VBoxContainer/ScoreLabel
@onready var distance_label: Label = $UI/Panel/VBoxContainer/DistanceLabel
@onready var retry_button: Button = $UI/Panel/VBoxContainer/RetryButton
@onready var menu_button: Button = $UI/Panel/VBoxContainer/MenuButton
@onready var button_sfx: AudioStreamPlayer = $ButtonSFX

func _ready() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	# Display final stats
	score_label.text = "SCORE: %07d" % GameData.final_score
	distance_label.text = "DISTANCE: %d m" % GameData.final_distance

func _on_retry_pressed() -> void:
	if button_sfx and button_sfx.stream:
		button_sfx.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_menu_pressed() -> void:
	if button_sfx and button_sfx.stream:
		button_sfx.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
