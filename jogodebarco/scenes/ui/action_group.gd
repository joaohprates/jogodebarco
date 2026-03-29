extends HBoxContainer

@onready var ActionButton = $Action
@onready var AddCrew = $Crew/AddCrew
@onready var RmCrew = $Crew/RmCrew
@onready var Name = $Action/Name
@onready var Counter = $Action/Counter

var action : Manned
signal update

var _icons_texture = preload("res://assets/Icones.png")
var _icon_map = {
	"Movement": 0,
	"LeftCannon": 1,
	"RightCannon": 2,
	"Repair": 3,
	"Gavea": 4
}

func _ready() -> void:
	ActionButton.connect("toggled", action_toggle)
	AddCrew.connect("pressed", add_crew)
	RmCrew.connect("pressed", rm_crew)
	connect("update", update_text)
	call_deferred('_setup_icon')
	call_deferred('update_text')

func _setup_icon():
	if action == null:
		return
	var idx = _icon_map.get(action.name, -1)
	if idx < 0:
		return
	var tex_size = _icons_texture.get_size()
	var frame_w = tex_size.x / 5.0
	var frame_h = tex_size.y
	var atlas = AtlasTexture.new()
	atlas.atlas = _icons_texture
	atlas.region = Rect2(idx * frame_w, 0, frame_w, frame_h)
	ActionButton.icon = atlas
	ActionButton.expand_icon = true
	ActionButton.custom_minimum_size = Vector2(96, 96)
	ActionButton.flat = true

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
