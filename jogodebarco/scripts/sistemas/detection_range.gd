extends Area2D

var player_in = false
var player_out = true

func _ready() -> void:
	connect("area_entered", _player_enter)
	connect("area_exited", _player_exit)

func _player_enter(_area):
	player_in = true
	player_out = false
	
func _player_exit(_area):
	player_in = false
	player_out = true
