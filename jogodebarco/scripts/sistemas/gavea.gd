extends Manned
class_name Gavea

@onready var camera: Camera2D = get_parent().get_node("Camera")

@export var base_zoom := 1.0
@export var max_zoom_out := 0.6

func _ready() -> void:
	super()
	crew = 0
	max_crew = 2
	parent.connect("crew_reset", reset_crew)
	_recalculate_stats()


func allocate(n: int):
	super.allocate(n)
	_recalculate_stats()


func deallocate(n: int):
	super.deallocate(n)
	_recalculate_stats()


func reset_crew() -> void:
	crew = 0
	_recalculate_stats()


func _recalculate_stats():
	var factor := 0.0

	if max_crew > 0:
		factor = float(crew) / float(max_crew)

	factor = clamp(factor, 0.0, 1.0)

	var zoom_value = lerp(base_zoom, max_zoom_out, factor)

	camera.zoom = Vector2(zoom_value, zoom_value)
