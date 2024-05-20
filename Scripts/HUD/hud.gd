extends CanvasLayer

@onready var lives_number = $Lives/Label/LivesNumber
@onready var timer_label = $Time/TimerLabel
@onready var timer = $Timer

func _ready():
	timer_label.text = str(PlayerStats.total_time)
	lives_number.text = str(PlayerStats.player_lives)

func _on_timer_timeout():
	PlayerStats.total_time += 1
	timer_label.text = str(PlayerStats.total_time)
	timer.start()

func _on_player_controller_update_lives(lives: int):
	lives_number.text = str(lives)
