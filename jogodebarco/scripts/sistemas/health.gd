extends Node
class_name Health

@export var max_health: int = 10
var atual_value: int

signal change(atual_value, max_health)
signal died

func _ready():
	atual_value = max_health / 2
	emit_signal("change", atual_value, max_health)

func allow_damage(damage: int):
	if atual_value <= 0:
		return

	atual_value -= damage
	atual_value = clamp(atual_value, 0, max_health)
	emit_signal("change", atual_value, max_health)
	
	if atual_value == 0:
		print("emitindo sinal")
		emit_signal("died")
	print("DANO EM:", owner.name, "vida:", atual_value)
	
func regen(valor: int):
	atual_value += valor
	atual_value = clamp(atual_value, 0, max_health)
	emit_signal("change", atual_value, max_health)
