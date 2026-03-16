extends Area2D
var on_personal_space: bool = false

func _ready() -> void:
	connect("area_entered",entered_space)
	connect("area_exited", exited_space)

func entered_space(_area: Area2D):
	on_personal_space = true


func exited_space(_area: Area2D):
	on_personal_space = false
