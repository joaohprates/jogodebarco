extends HBoxContainer

@onready var ActionButton = $Action
@onready var AddCrew = $Crew/AddCrew
@onready var RmCrew = $Crew/RmCrew
@onready var Name = $Action/Name
@onready var Counter = $Action/Counter

var action : Manned
signal update

func _ready() -> void:
	ActionButton.connect("toggled", action_toggle)
	AddCrew.connect("pressed", add_crew)
	RmCrew.connect("pressed", rm_crew)
	connect("update", update_text)
	call_deferred('update_text')

func _process(_delta: float) -> void:
	update_text()

func action_toggle(toggl) -> void:
	action.toggle(toggl)

func add_crew() -> void:
	action.allocate(1)
	emit_signal('update')

func rm_crew() -> void:
	action.deallocate(1)
	emit_signal('update')

func update_text() -> void:
	Name.text = action.name
	Counter.text = str(action.crew) + '/' + str(action.max_crew)
