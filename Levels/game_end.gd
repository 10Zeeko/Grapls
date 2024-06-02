extends Control

@export var resource : String
@onready var timer_label = $Time/TimerLabel

func _ready():
	if (timer_label != null):
		timer_label.text = str(PlayerStats.total_time)

func _on_play_pressed():
	get_tree().change_scene_to_file(resource)


func _on_exit_pressed():
	get_tree().quit()
