extends Node

class_name Manned

var crew : int
var max_crew : int
var parent
var activated = false

func _ready() -> void:
	parent = get_parent()

func allocate(n : int):
	if crew < max_crew and parent.free_crew > 0:
		crew = crew + n
		if parent.free_crew != null:
			parent.free_crew -= 1

func deallocate(n : int):
	if crew > 0:
		crew = crew - n
		if parent.free_crew != null and parent.free_crew < parent.crew:
			parent.free_crew += 1

func toggle(tog_bool: bool):
	activated = tog_bool
	print(name +' activated=' + str(activated))

func reset_crew() -> void:
	crew = 0
