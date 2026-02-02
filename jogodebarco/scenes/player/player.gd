extends Boat

func _ready() -> void:
	crew = 5
	free_crew = 5
	Global.Player = self
	$HUD/ActBar/Cannon.action = $Cannon
	$HUD/ActBar/Move.action = $Movement
	$HUD/ActBar/Repair.action = $Repair
	$HUD/ActBar/ResetCrew.connect('pressed', reset_button)

func _process(delta: float) -> void:
	$HUD/ActBar/CrewCount.text = 'Crew: ' + str(free_crew) + '/' + str(crew)

func reset_button() -> void:
	emit_signal("crew_reset")
	free_crew = crew
