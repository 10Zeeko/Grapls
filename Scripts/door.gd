extends Area2D

@export var resource : String

func _on_body_entered(body):
	call_deferred("_change_scene")

func _change_scene():
	if is_inside_tree():
		get_tree().change_scene_to_file(resource)
	else:
		print("Node is no longer inside the scene tree.")
