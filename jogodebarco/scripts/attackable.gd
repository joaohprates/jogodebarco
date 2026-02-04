extends Node

class_name  Attackable

@onready var parent_sprite = get_parent().get_node("Sprite")

var selectable = true
var is_target = false
var on_range = false

func _ready() -> void:
	$DetectBox/CollisionShape2D.shape.size = Vector2(parent_sprite.texture.get_width(), parent_sprite.texture.get_height()) 
	$TooFar.position.y = parent_sprite.texture.get_height() / 2
	$DetectBox.connect('mouse_entered', mouse_hover)
	$DetectBox.connect('mouse_exited', mouse_out)
	

func _process(delta: float) -> void:
	if is_target:
		get_parent().get_node('Sprite').material = load("res://assets/shaders/attack_outline.tres")
		if !on_range:
			$TooFar.visible = true
		else:
			$TooFar.visible = false
	if !is_target and get_parent().get_node('Sprite').material == load("res://assets/shaders/attack_outline.tres"):
		get_parent().get_node('Sprite').material = null
	if !is_target:
		$TooFar.visible = false

func _take_damage(damage : int):
	print('dano recebido: ' + str(damage))

func mouse_hover():
	if selectable:
		Global.under_mouse = self
	
func mouse_out():
	Global.under_mouse = null
	get_parent().get_node('Sprite').material = null
