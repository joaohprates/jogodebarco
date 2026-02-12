extends Manned
class_name Repair

@export var regen_per_crew := 1
@export var tick_time := 1.0

var health: Health
var timer: Timer

func _ready() -> void:
	super()

	health = parent.get_node("Health")

	timer = Timer.new()
	timer.wait_time = tick_time
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.connect("timeout", _on_tick)

	crew = 0
	max_crew = 2
	parent.connect("crew_reset", reset_crew)

func _on_tick():
	if crew <= 0:
		return
	if health.atual_value >= health.max_health:
		return

	health.regen(crew * regen_per_crew)
