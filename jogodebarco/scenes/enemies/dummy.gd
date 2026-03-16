extends Node2D
@onready var health = $Health



func _ready() -> void:
	health.connect("died", die)
	
func die():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
