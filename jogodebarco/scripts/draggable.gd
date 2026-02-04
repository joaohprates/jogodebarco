extends Node2D

@onready var parent_sprite = get_parent().get_node("Sprite")

var under_mouse = false

func _ready() -> void:
	$Area2D/CollisionShape2D.shape.size = Vector2(parent_sprite.texture.get_width(), parent_sprite.texture.get_height())
	$Area2D.connect("mouse_entered", mouse_in)
	$Area2D.connect("mouse_exited", mouse_out)

func _process(delta: float) -> void:
	if Input.is_action_pressed("left_click") and under_mouse:
		owner.global_position = get_global_mouse_position()

func mouse_in():
	under_mouse = true

func mouse_out():
	under_mouse = false
