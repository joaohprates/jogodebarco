extends Label

func _physics_process(delta: float) -> void:
	text = 'Treasures ' +str(Global.treasuresCollected)+'/5'
