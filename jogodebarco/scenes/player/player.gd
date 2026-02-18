extends Boat


signal repair_kits_changed(current, max)
@export var repair_kits_max := 3

enum States {IDLE, AIM_RIGHT, AIM_LEFT, STEER}
var player_state = States.IDLE

var repair_kits := 3

@onready var movement: Movement = $Movement

var move_target: Vector2
var has_target := false
const STOP_DISTANCE := 5.0

func _ready() -> void:
	print("RepairKitButton ready")
	crew = 6
	free_crew = crew
	Global.Player = self
	
	$Attackable.selectable = false
	$HUD/ActBar/RightCannon.action = $RightCannon
	$HUD/ActBar/LeftCanon.action = $LeftCannon
	$HUD/ActBar/Move.action = $Movement
	$HUD/ActBar/Repair.action = $Repair
	$HUD/ActBar/ResetCrew.connect('pressed', reset_button)
	
	$HUD/PlayerHealthBar.setup($Health)
	
	$HUD/RepairKitButton.setup(self)
	$HUD/RepairKitButton.connect("pressed", use_repair_kit)
	emit_signal("repair_kits_changed", repair_kits, repair_kits_max)
	
func _physics_process(delta: float) -> void:
	
	$HUD/ActBar/CrewCount.text = "Crew: %d/%d" % [free_crew, crew]

	
	if $RightCannon.activated:
		aim_mode($RightCannon)
	if $LeftCannon.activated:
		aim_mode($LeftCannon)

	
	if has_target and not movement.anchored:
		_move_to_target(delta)
	else:
		velocity = Vector2.ZERO
		move_and_slide()

func aim_mode(cannon : Cannon):
	if Global.under_mouse is Attackable:
			Global.under_mouse.owner.get_node('Sprite').material = load("res://assets/shaders/attack_hover_outline.tres")
			if Input.is_action_just_pressed("left_click"):
				cannon.target = Global.under_mouse
				cannon.target.is_target = true
	if Input.is_action_just_pressed("right_click"): 
		if cannon.target != null:
			var old_target = cannon.target
			cannon.target = null
			if $RightCannon.target != old_target and $LeftCannon.target != old_target:
				old_target.is_target = false

func reset_button() -> void:
	emit_signal("crew_reset")
	free_crew = crew
	
func use_repair_kit():
	if repair_kits <= 0:
		return

	var health: Health = $Health
	if health.atual_value >= health.max_health:
		return

	repair_kits -= 1

	var heal_amount := int(health.max_health * 0.25)
	health.regen(heal_amount)

	emit_signal("repair_kits_changed", repair_kits, repair_kits_max)
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			move_target = get_global_mouse_position()
			has_target = true
		
func _move_to_target(delta: float):
	var dir = move_target - global_position
	var distance = dir.length()

	if distance <= STOP_DISTANCE:
		has_target = false
		movement.speed = 0
		return

	dir = dir.normalized()

	
	movement.speed += movement.accel * delta
	movement.speed = clamp(movement.speed, 0, movement.max_speed)

	velocity = dir * movement.speed
	move_and_slide()

	
	rotation = dir.angle() + PI / 2
