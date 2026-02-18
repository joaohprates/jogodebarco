extends Boat
class_name Enemy

var state: States = States.IDLE
var b_state: BattleStates = BattleStates.IDLE
var target
var intelligence = 2
var relative_side

@onready var r_cannon = $RightCannon
@onready var l_cannon = $LeftCannon
@onready var personal_space = $PersonalSpace
@onready var detection = $DetectionRange
@onready var crew_timer = $CrewTimer
@onready var think_timer = $ThinkTimer

enum States {
	IDLE,
	ATTACK
}
enum BattleStates{
	IDLE,
	CHASE,
	ORBIT,
	TOO_CLOSE
}

func _ready() -> void:
	super()
	crew = 4
	free_crew = crew
	$Health.max_health = 20
	detection.connect("area_entered", _player_detected)
	crew_timer.wait_time = 5 - intelligence
	crew_timer.connect("timeout", distribute_combat_crew)
	think_timer.wait_time = 3/intelligence
	think_timer.connect('timeout', _think)

func _physics_process(delta: float) -> void:
	if state == States.ATTACK:
		_attack()
	elif state == States.IDLE:
		idle_crew()

func _attack():
	if $PersonalSpace.on_personal_space:
		b_state = BattleStates.TOO_CLOSE
	match b_state:
		BattleStates.CHASE:
			pass
		BattleStates.ORBIT:
			pass
		BattleStates.TOO_CLOSE:
			pass

func distribute_combat_crew():
	if state != States.ATTACK:
		return
	emit_signal("crew_reset")
	match b_state:
		BattleStates.CHASE:
			#alocar 2 ao movimento, 1 em cada canhão
			l_cannon.allocate(1)
			r_cannon.allocate(1)
			print('entered chase')
		BattleStates.ORBIT:
			var active_cannon = null
			if relative_side < 1:
				active_cannon = l_cannon
			else:
				active_cannon = r_cannon
			active_cannon.allocate(2)
		BattleStates.TOO_CLOSE:
			#2 em movimento 1 em cada canhão
			l_cannon.allocate(1)
			r_cannon.allocate(1)
	_combat_debug()

func _think():
	if state != States.ATTACK:
		return
	relative_side = (target.global_position.x - global_position.x) * cos(rotation)
	if relative_side == 0:
		if cos(rotation) == 0:
			relative_side = 1
		else:
			relative_side = rotation_degrees
	if personal_space.on_personal_space:
		b_state = BattleStates.TOO_CLOSE
	else:
		if r_cannon.in_aim or l_cannon.in_aim:
			b_state = BattleStates.ORBIT
		else:
			b_state = BattleStates.CHASE

func idle_crew():
	reset_crew()

func _player_detected(area):
	if state != States.IDLE:
		return
	state = States.ATTACK
	b_state = BattleStates.CHASE
	r_cannon.target = area.owner.get_node('Attackable')
	l_cannon.target = area.owner.get_node('Attackable')
	target = area.owner

func _combat_debug():
	print('state: '+ str(States.find_key(state)) + str(state))
	print('battle_state: '+ str(BattleStates.find_key(b_state)) + str(b_state))
	print('Intelligence: '+ str(intelligence))
	print('relative side: '+ str(relative_side))
