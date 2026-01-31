extends Node

class_name Manned

var crew : int
var max_crew : int

func allocate(n : int):
	if crew > max_crew:
		crew = crew + 1
	if get_parent().free_crew != null:
		get_parent().free_crew -= 1

func deallocate(n : int):
	if crew > 0:
		crew = crew - 1
	if get_parent().free_crew != null:
		get_parent().free_crew -= 1
