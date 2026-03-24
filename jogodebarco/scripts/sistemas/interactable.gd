extends Node

## Ao ser adicionado a outro Node, esse node se tornará interagível, e executará sua função interact() quando
## um PlayerCharacter apertar o botão de interagir dentro da área limite
class_name Interactable

@onready var interact_zone: Area2D = $InteractZone
@onready var outline = load("res://assets/shaders/interactable_outline.tres")
@onready var press_f = $Label

var player_in_range: bool = false
var message: String = 'interact'

func _ready() -> void:
	press_f.position.y = owner.get_node('Sprite').texture.get_height()/2
	interact_zone.connect('area_entered',_player_entered)
	interact_zone.connect('area_exited', _player_exited)

func _physics_process(_delta: float) -> void:
	if player_in_range:
		if Input.is_action_just_pressed("interact"):
			interact()
	else: return

func interact():
	if get_parent().interact != null:
		get_parent().interact()

func _player_entered(area):
	press_f.text = 'press \'F\' to ' + message
	if area.owner is PlayerCharacter or area.owner is Player:
		player_in_range = true
		press_f.visible = true
		owner.get_node('Sprite').material = outline

func _player_exited(area):
	if area.owner is PlayerCharacter or area.owner is Player:
		player_in_range = false
		press_f.visible = false
		owner.get_node('Sprite').material = null
