extends Node2D

func _ready() -> void:
	$Interactable.message = 'repair'

func interact():
	var player = Global.Player
	if player == null:
		return

	if player.repair_kits >= player.repair_kits_max:
		return

	player.repair_kits += 1
	player.emit_signal("repair_kits_changed", player.repair_kits, player.repair_kits_max)
	queue_free()
