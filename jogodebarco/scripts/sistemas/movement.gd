extends Manned

func _ready() -> void:
	super()
	crew = 0
	max_crew = 2
	parent.connect('crew_reset', reset_crew)
