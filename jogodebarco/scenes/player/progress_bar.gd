extends ProgressBar

var health: Health

func setup(h: Health):
	health = h
	max_value = health.max_health
	value = health.atual_value
	health.connect("change", _on_health_change)

func _on_health_change(atual, _max):
	value = atual
