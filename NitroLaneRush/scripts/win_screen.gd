extends Node

# Win Screen Script - Nitro Lane Rush

@onready var score_label: Label = $UI/Panel/VBoxContainer/ScoreLabel
@onready var distance_label: Label = $UI/Panel/VBoxContainer/DistanceLabel
@onready var play_again_button: Button = $UI/Panel/VBoxContainer/PlayAgainButton
@onready var menu_button: Button = $UI/Panel/VBoxContainer/MenuButton
@onready var button_sfx: AudioStreamPlayer = $ButtonSFX

func _ready() -> void:
	play_again_button.pressed.connect(_on_play_again_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	score_label.text = "SCORE: %07d" % GameData.final_score
	distance_label.text = "DISTANCE: %d m" % GameData.final_distance

func _on_play_again_pressed() -> void:
	if button_sfx and button_sfx.stream:
		button_sfx.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_menu_pressed() -> void:
	if button_sfx and button_sfx.stream:
		button_sfx.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
