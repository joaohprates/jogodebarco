extends Manned
class_name Movement

var speed := 0.0

@export var base_max_speed := 200.0
@export var base_accel := 50.0
@export var base_deaccel := 40.0

@export var max_speed := 200.0
@export var accel := 50.0
@export var deaccel := 40.0

var t_speed := 0.0
@export var max_t_speed : float = 0.2
@export var t_accel : float = 0.2
@export var t_deaccel : float = 0.5

var anchored := false


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
	var factor := 1.0

	if max_crew > 0:
		factor = float(crew) / float(max_crew)

	
	factor = clamp(factor, 0.0, 1.0)

	max_speed = base_max_speed * factor
	accel = base_accel * factor
	deaccel = base_deaccel
