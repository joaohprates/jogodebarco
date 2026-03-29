extends Node2D

@onready var collectZone: Area2D = $CollectZone
@onready var particles:CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	collectZone.connect("area_entered",_collected)

func _collected(area: Area2D):
	print('tesouro coletado')
	particles.emitting = true
	$Sprite.visible = false
	await get_tree().create_timer(0.5).timeout
	Global.treasuresCollected += 1
	get_tree().root.remove_child(self)
	queue_free()
