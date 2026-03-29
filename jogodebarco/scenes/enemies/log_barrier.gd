extends StaticBody2D

@onready var health = $Health

func _ready() -> void:
	health.connect("died", die)
	$Health.max_health = 10
func die():
	queue_free()
