extends CharacterBody2D

## Entidade que pode ser movimentada pelo player
class_name PlayerCharacter

@onready var HUD = $HUD

var speed: float = 200
var dir:Vector2 = Vector2.ZERO

func _ready() -> void:
	Global.Player_char = self

func _process(delta: float) -> void:
	_handle_inputs()

func _physics_process(delta: float) -> void:
	velocity = speed * dir.normalized()
	move_and_slide()

func _handle_inputs():
	dir.y =  Input.get_action_raw_strength('down') - Input.get_action_raw_strength('up')
	dir.x =  Input.get_action_raw_strength('right') - Input.get_action_raw_strength('left')
	if Input.is_action_just_pressed("escape")and HUD.get_children() != []:
		HUD.remove_child(HUD.get_children()[0])
