extends CharacterBody2D

class_name Boat

@onready var movement: Movement = $Movement

var crew := 0
var free_crew := 0

signal crew_reset

func _ready():
	connect("crew_reset", reset_crew)

func _physics_process(delta):
	_handle_movement(delta)

func reset_crew():
	free_crew = crew
	movement.reset_crew()

func _handle_movement(delta):

	if movement.anchored:
		movement.speed -= movement.deaccel * delta
	else:
		movement.speed += movement.accel * delta

	movement.speed = clamp(movement.speed, 0, movement.max_speed)

	var forward = Vector2.UP.rotated(rotation)
	velocity = forward * movement.speed

	move_and_slide()
