extends ProgressBar

@onready var health = get_parent().get_parent()

func _ready():
	health.connect("change", _on_change)
	max_value = health.max_health
	value = health.atual_value
	
func setup(h: Health):
	health = h
	health.connect("change", _on_change)
	max_value = health.max_health
	value = health.atual_value
	
func _on_change(atual, max):
	value = atual
