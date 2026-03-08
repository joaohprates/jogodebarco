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
	think_timer.wait_time = 1#3/intelligence
	think_timer.connect('timeout', _think)

func _physics_process(delta: float) -> void:
	super(delta)
	if state == States.ATTACK:
		_attack(delta)
	elif state == States.IDLE:
		idle_crew()

func _attack(delta):
	#_handle_movement(delta)
	match b_state:
		BattleStates.CHASE:
			if snapped(rad_to_deg(global_position.angle_to_point(target.global_position) - rotation), 2) != -90 :
				turn(target_relative(target))
		BattleStates.ORBIT:
			turn(target_relative(target))
		BattleStates.TOO_CLOSE:
			if snapped(rad_to_deg((target.global_position - global_position).angle() - rotation), 2) != 90:
				turn(-target_relative(target))

func distribute_combat_crew():
	if state != States.ATTACK:
		return
	emit_signal("crew_reset")
	match b_state:
		BattleStates.CHASE:
			#alocar 2 ao movimento, 1 em cada canhão
			movement.allocate(2)
			l_cannon.allocate(1)
			r_cannon.allocate(1)
			print('entered chase')
		BattleStates.ORBIT:
			movement.allocate(1)
			var active_cannon = null
			if relative_side < 1:
				active_cannon = l_cannon
				l_cannon.get_node('Range/CollisionShape2D').debug_color = Color(0.702, 0.0, 0.012, 0.42)
				r_cannon.get_node('Range/CollisionShape2D').debug_color = Color(0.0, 0.6, 0.702, 0.42)
			else:
				active_cannon = r_cannon
				r_cannon.get_node('Range/CollisionShape2D').debug_color = Color(0.702, 0.0, 0.012, 0.42)
				l_cannon.get_node('Range/CollisionShape2D').debug_color = Color(0.0, 0.6, 0.702, 0.42)
			active_cannon.allocate(2)
		BattleStates.TOO_CLOSE:
			#2 em movimento 1 em cada canhão
			movement.allocate(2)
			l_cannon.allocate(1)
			r_cannon.allocate(1)
	_combat_debug()

func _think():
	if state != States.ATTACK:
		return
	relative_side = target_relative(target)
	if r_cannon.in_aim or l_cannon.in_aim:
		b_state = BattleStates.ORBIT
	else:
		if personal_space.on_personal_space and b_state != BattleStates.ORBIT:
			b_state = BattleStates.TOO_CLOSE
		else:
			b_state = BattleStates.CHASE

## Se [param d] for [code]1[/code], vira o barco para a direita, se [param d] for 
##[code]-1[/code], vira para a esquerda
func turn(d : int):
	if d == 0:
		d = 1
	rotate(d * 0.005)

## Retorna [code]1[/code]  se [param tgt] estiver à sua direita, e [code]-1[/code] se estiver à sua esquerda
func target_relative(tgt):
	return sign(sin(rotation - global_position.angle_to_point(target.global_position) + PI / 2))

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
	_think()

func _combat_debug():
	print('state: '+ str(States.find_key(state)) + str(state))
	print('battle_state: '+ str(BattleStates.find_key(b_state)) + str(b_state))
	print('Intelligence: '+ str(intelligence))
	print('relative side: '+ str(relative_side))
