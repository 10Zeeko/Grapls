extends Control

@export var resource : PackedScene

func _on_play_pressed():
	get_tree().change_scene_to_packed(resource)


func _on_exit_pressed():
	get_tree().quit()
