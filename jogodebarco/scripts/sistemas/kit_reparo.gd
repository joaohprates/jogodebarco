extends Button

@onready var label := $KitCount
var player: Boat

func setup(p: Boat):
	player = p
	player.connect("repair_kits_changed", _on_kits_changed)
	_on_kits_changed(player.repair_kits, player.repair_kits_max)

func _on_kits_changed(current, max):
	label.text = str(current) + "/" + str(max)
	disabled = false
