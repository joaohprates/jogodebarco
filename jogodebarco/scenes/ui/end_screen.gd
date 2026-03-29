extends Control

@onready var continuar: Button = $Panel/MarginContainer/Continue
@onready var menu: Button = $Panel/MarginContainer/Menu
@onready var treasures: Array = [$Node2D/HBoxContainer/TextureRect,$Node2D/HBoxContainer/TextureRect2,$Node2D/HBoxContainer/TextureRect3]

func _ready() -> void:
	continuar.connect('pressed', goto_island)
	menu.connect("pressed", goto_menu)
	for chest in treasures:
		if Global.treasuresCollected == 0:
			light_up(chest)
		else:
			Global.treasuresCollected -= 1

func goto_menu():
	SceneManager.switch_scene("res://scenes/ui/Tela_Inicial.tscn")

func goto_island():
	SceneManager.switch_scene("res://scenes/locations/island.tscn")

func light_up(treasure: TextureRect):
	treasure.modulate = Color()
