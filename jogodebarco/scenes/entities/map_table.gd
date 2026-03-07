extends Node2D

@onready var map_screen = load("res://scenes/ui/map_screen.tscn")

func interact():
	Global.Player_char.HUD.add_child(map_screen.instantiate())
