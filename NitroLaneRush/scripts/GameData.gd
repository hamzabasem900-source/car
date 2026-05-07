extends Node

# GameData Autoload Singleton - Nitro Lane Rush
# Persists data between scenes

var final_score: int = 0
var final_distance: int = 0
var high_score: int = 0

func save_high_score() -> void:
	if final_score > high_score:
		high_score = final_score
