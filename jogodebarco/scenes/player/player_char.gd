extends CharacterBody2D

## Entidade que pode ser movimentada pelo player
class_name PlayerCharacter

@onready var HUD = $HUD
@onready var animator = $AnimationPlayer

var speed: float = 100
var dir:Vector2 = Vector2.ZERO
var facing: String = "front"

func _ready() -> void:
	Global.Player_char = self

func _process(_delta: float) -> void:
	_handle_inputs()

func _physics_process(_delta: float) -> void:
	if dir != Vector2.ZERO:
		if abs(dir.x) >= abs(dir.y):
			if dir.x > 0:
				facing = "right"
			else:
				facing = "left"
		else:
			if dir.y > 0:
				facing = "front"
			else:
				facing = "back"

	if velocity == Vector2.ZERO:
		animator.play("idle_" + facing)
	else:
		animator.play("walk_" + facing)
	velocity = speed * dir.normalized()
	move_and_slide()

func _handle_inputs():
	dir.y =  Input.get_action_raw_strength('down') - Input.get_action_raw_strength('up')
	dir.x =  Input.get_action_raw_strength('right') - Input.get_action_raw_strength('left')
	if Input.is_action_just_pressed("escape")and HUD.get_children() != []:
		HUD.remove_child(HUD.get_children()[0])
