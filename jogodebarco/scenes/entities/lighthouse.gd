extends Node2D

func _ready() -> void:
	$Interactable.message = 'Leave'
	$Interactable/InteractZone/CollisionShape2D.shape.radius = 480

func interact():
	SceneManager.switch_scene("res://scenes/ui/end_screen.tscn")
