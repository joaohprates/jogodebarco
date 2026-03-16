extends Node

@onready var load_screen: Node2D = preload("res://scenes/autoload/loading_screen.tscn").instantiate()

var next_scene = null

var scene_stack = []

func _ready() -> void:
	scene_stack = [get_tree().current_scene]

## Pausa a cena atual e carrega uma nova cena em cima com base no caminho cornecido
func load_on_top(scene_path: String):
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().root.add_child(load_screen)
	load_screen.load_scene(scene_path)
	await load_screen.scene_loaded
	scene_stack.append(get_tree().current_scene)
	
## Volta para a cena anterior no [param scene_stack]
func go_back():
	if scene_stack.size() == 1:
		print('não há mais cenas')
		return
	scene_stack[-1].queue_free()
	scene_stack.pop_back()
	get_tree().current_scene = scene_stack[-1]
	scene_stack[-1].process_mode = Node.PROCESS_MODE_ALWAYS

func switch_scene(scene_path: String):
	get_tree().root.add_child(load_screen)
	scene_stack.pop_back()
	get_tree().root.remove_child(get_tree().current_scene)
	load_screen.load_scene(scene_path)
	await load_screen.scene_loaded
	scene_stack.append(get_tree().current_scene)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('interact'):
		go_back()
	if event.is_action_pressed('up'):
		load_on_top("res://scenes/locations/Main Sea.tscn")
