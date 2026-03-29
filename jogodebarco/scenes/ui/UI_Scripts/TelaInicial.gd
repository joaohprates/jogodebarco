extends Control

func _on_JogarButton_pressed():
	SceneManager.switch_scene("res://scenes/locations/island.tscn")

func _on_SairButton_pressed():
	get_tree().quit()
