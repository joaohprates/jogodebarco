extends Area2D
var on_personal_space: bool = false

func entered_space(area: Area2D):
	on_personal_space = true

func exited_space(area: Area2D):
	on_personal_space = true
