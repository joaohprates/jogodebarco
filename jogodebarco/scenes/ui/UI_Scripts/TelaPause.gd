extends Control

@onready var pause_sprite: Sprite2D = $Center/PauseSprite
var anim_timer := 0.0
var anim_speed := 0.15

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if not visible:
		return
	anim_timer += delta
	if anim_timer >= anim_speed:
		anim_timer = 0.0
		pause_sprite.frame = (pause_sprite.frame + 1) % pause_sprite.hframes

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		_toggle_pause()
		get_viewport().set_input_as_handled()

func _toggle_pause():
	if get_tree().paused:
		_resume()
	else:
		_pause()

func _pause():
	visible = true
	get_tree().paused = true

func _resume():
	visible = false
	get_tree().paused = false

func _on_resume_pressed():
	_resume()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/Tela_Inicial.tscn")
