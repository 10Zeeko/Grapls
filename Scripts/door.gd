extends Area2D

@export var resource : PackedScene

func _ready():
	pass # Replace with function body.


func _on_body_entered(body):
	get_tree().change_scene_to_packed(resource)
