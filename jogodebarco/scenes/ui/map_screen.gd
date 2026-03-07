extends Control

@onready var map_button = $ExpedButton/Button

func _ready() -> void:
	map_button.connect("pressed",press_button)

func press_button():
	SceneManager.switch_scene("res://scenes/locations/Main Sea.tscn")
