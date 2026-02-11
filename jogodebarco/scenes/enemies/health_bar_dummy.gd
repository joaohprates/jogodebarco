extends Node2D

@onready var bar := $ProgressBar
@onready var health := get_parent().get_node("Health")

func _ready():
	bar.max_value = health.max_health
	bar.value = health.atual_value
	health.connect("change", _on_health_change)

func _process(_delta):
	global_position = get_parent().global_position + Vector2(0, -40)

func _on_health_change(atual, _max):
	bar.value = atual
