extends Area2D

@export var resource : String

func _on_body_entered(body):
	get_tree().change_scene_to_file(resource)
	print (get_tree().current_scene.scene_file_path)
