extends Node2D

@onready var progress_bar = $CanvasLayer/Control/MarginContainer/ProgressBar

var loading_scene: String

signal scene_loaded

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not loading_scene:
		return
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(loading_scene, progress)
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		var progress_value = progress[0] * 100
		progress_bar.value = move_toward(progress_bar.value, progress_value, delta * 20)
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		progress_bar.value = move_toward(progress_bar.value, 100.0, delta * 150)
		if progress_bar.value > 99:
			var new_scene = ResourceLoader.load_threaded_get(loading_scene).instantiate()
			get_tree().root.add_child(new_scene)
			get_tree().current_scene = new_scene
			SceneManager.load_screen = load("res://scenes/autoload/loading_screen.tscn").instantiate()
			scene_loaded.emit()
			print('carregamento finalizado')
			queue_free()

func load_scene(scene: String):
	loading_scene = scene
	ResourceLoader.load_threaded_request(loading_scene)
	
