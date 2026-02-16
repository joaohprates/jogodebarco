extends Boat
class_name Enemy

var state: States = States.IDLE
var b_state: BattleStates = BattleStates.IDLE
var target
var intelligence = 2
var relative_side

@onready var r_cannon = $RightCannon
@onready var l_cannon = $LeftCannon
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
	b_state = BattleStates.CHASE
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
	reset_crew()
	match b_state:
		BattleStates.CHASE:
			#alocar 2 ao movimento, 1 em cada canhão
			l_cannon.allocate(1)
			r_cannon.allocate(1)
		BattleStates.ORBIT:
			var active_cannon = null
			if relative_side > 1:
				active_cannon = l_cannon
			else:
				active_cannon = r_cannon
			active_cannon.allocate(2)
		BattleStates.TOO_CLOSE:
			#2 em movimento 1 em cada canhão
			l_cannon.allocate(1)
			r_cannon.allocate(1)

func _think():
	if state != States.ATTACK:
		return
	relative_side = (target.global_position - global_position) * cos(rotation)
	if relative_side == 0:
		if cos(rotation) == 0:
			relative_side = 1
		else:
			relative_side = rotation_degrees

func idle_crew():
	reset_crew()

func _player_detected(area):
	state = States.ATTACK
	r_cannon.target = area.owner.get_node('Attackable')
	l_cannon.target = area.owner.get_node('Attackable')
	target = area.owner

func _combat_debug():
	print('state: '+ str(state))
	print('battle_state: '+ str(state))
	print('state: '+ str(state))
	print('state: '+ str(state))
