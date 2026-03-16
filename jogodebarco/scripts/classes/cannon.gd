extends Manned

class_name Cannon

@onready var cooldown = $Timer
@onready var rangec = $Range

var target
var on_range = []
var in_aim = false
var can_shoot = true
var base_damage = 4
var cooldown_time = 1

func _ready() -> void:
	super()
	rangec.connect('area_entered', entered_range)
	rangec.connect('area_exited', exited_range)
	cooldown.connect('timeout', cooldown_end)

func _process(_delta: float) -> void:
	if target != null:
		_attack(target)

func _attack(tgt):
	if on_range.has(target):
		in_aim = true
	else:
		in_aim = false
	if in_aim and can_shoot:
		if crew > 0:
			_shoot(tgt)

func _shoot(tgt : Attackable):
	$CannonSmoke.emitting = true
	can_shoot = false
	cooldown.start(calculate_cooldown())
	tgt._take_damage(base_damage)
	
func calculate_cooldown():
	return float (cooldown_time*max_crew)/crew

func entered_range(area : Area2D):
	area.owner.on_range = true
	on_range.append(area.owner)
	
func exited_range(area : Area2D):
	area.owner.on_range = false
	on_range.erase(area.owner)
func cooldown_end():
	can_shoot = true
