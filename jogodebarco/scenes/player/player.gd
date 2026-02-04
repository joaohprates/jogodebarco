extends Boat

enum States {IDLE, AIM_RIGHT, AIM_LEFT, STEER}
var player_state = States.IDLE

func _ready() -> void:
	crew = 7
	free_crew = crew
	Global.Player = self
	$Attackable.selectable = false
	$HUD/ActBar/RightCannon.action = $RightCannon
	$HUD/ActBar/LeftCanon.action = $LeftCannon
	$HUD/ActBar/Move.action = $Movement
	$HUD/ActBar/Repair.action = $Repair
	$HUD/ActBar/ResetCrew.connect('pressed', reset_button)

func _process(delta: float) -> void:
	$HUD/ActBar/CrewCount.text = 'Crew: ' + str(free_crew) + '/' + str(crew)
	if $RightCannon.activated:
		aim_mode($RightCannon)
			
	if $LeftCannon.activated:
		aim_mode($LeftCannon)

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
