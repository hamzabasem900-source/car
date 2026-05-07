extends Node

# Instructions Screen Script - Nitro Lane Rush

@onready var back_button: Button = $UI/BackButton
@onready var button_sfx: AudioStreamPlayer = $ButtonSFX

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	if button_sfx and button_sfx.stream:
		button_sfx.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
