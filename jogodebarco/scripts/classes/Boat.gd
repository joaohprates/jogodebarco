extends CharacterBody2D

class_name Boat

var crew : int
var free_crew : int

signal crew_reset

func _ready() -> void:
	connect('crew_reset', reset_crew)

func reset_crew():
	free_crew = crew
