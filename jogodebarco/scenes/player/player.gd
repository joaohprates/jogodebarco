extends Boat

signal repair_kits_changed(current, max)
@export var repair_kits_max := 3

var mkp
@onready var helm

enum States {IDLE, AIM_RIGHT, AIM_LEFT, STEER}
var player_state = States.IDLE

var repair_kits := 3

var tgt = Vector2.ZERO

func _ready() -> void:
	
	crew = 6
	free_crew = crew

	Global.Player = self
	
	tgt = Vector2(global_position.x, global_position.y - 2)
	_initialize_var()
	helm = get_node("Helm")
	$Attackable.selectable = false
	$HUD/ActBar/RightCannon.action = $RightCannon
	$HUD/ActBar/LeftCanon.action = $LeftCannon
	$HUD/ActBar/Move.action = $Movement
	$HUD/ActBar/Repair.action = $Repair
	$HUD/ActBar/Gavea.action = $Gavea
	$HUD/ActBar/ResetCrew.connect("pressed", reset_button)
	
	$HUD/PlayerHealthBar.setup($Health)
	$HUD/RepairKitButton.setup(self)
	$HUD/RepairKitButton.connect("pressed", use_repair_kit)
	emit_signal("repair_kits_changed", repair_kits, repair_kits_max)
	
func _initialize_var():
	movement.speed = 0
	movement.anchored = true


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	$HUD/ActBar/CrewCount.text = "Crew: %d/%d" % [free_crew, crew]
	move()
	if $RightCannon.activated:
		aim_mode($RightCannon)
	if $LeftCannon.activated:
		aim_mode($LeftCannon)

	


func aim_mode(cannon : Cannon):
	if Global.under_mouse != null and is_instance_valid(Global.under_mouse):
		if Global.under_mouse is Attackable:
			Global.under_mouse.owner.get_node("Sprite").material = load("res://assets/shaders/attack_hover_outline.tres")
			if Input.is_action_just_pressed("left_click"):
				cannon.target = Global.under_mouse
				cannon.target.is_target = true

	if Input.is_action_just_pressed("r_click"): 
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

func move():
	var desired_angle = (tgt - global_position).angle() + PI/2
	var angle_diff = wrapf(desired_angle - rotation, -PI, PI)

	if abs(angle_diff) > 0.05:
		rotate(sign(angle_diff) * movement.t_accel)
func _input(event):
	if Input.is_action_just_pressed("r_click"):
		tgt = get_global_mouse_position()
		movement.anchored = false
