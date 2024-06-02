extends Control

@export var resource : String

func _on_play_pressed():
	get_tree().change_scene_to_file(resource)


func _on_exit_pressed():
	get_tree().quit()
