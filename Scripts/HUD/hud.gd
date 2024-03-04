extends Control

@onready var lives_number = $Lives/Label/LivesNumber
@onready var timer_label = $Time/TimerLabel
@onready var timer = $Timer

var total_time = 0

func update_lives(lives: int):
	lives_number.text = str(lives)

func _on_timer_timeout():
	total_time += 1
	timer_label.text = str(total_time)
	timer.start()
