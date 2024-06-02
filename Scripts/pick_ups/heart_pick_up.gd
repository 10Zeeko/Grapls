extends Area2D

@onready var audio_stream_player = $AudioStreamPlayer

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.add_lives()
		play_and_destroy()

func play_and_destroy():
	# Reparent the AudioStreamPlayer to the root of the scene tree
	audio_stream_player.get_parent().remove_child(audio_stream_player)
	get_tree().root.add_child(audio_stream_player)

	# Play the audio
	audio_stream_player.play()

	# Use a timer to delete the AudioStreamPlayer after the audio finishes playing
	var timer = Timer.new()
	timer.wait_time = audio_stream_player.stream.get_length()
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timeout"))
	add_child(timer)
	timer.start()

	# Destroy the pickup object
	queue_free()

func _on_timeout():
	# Remove the AudioStreamPlayer from the scene tree
	audio_stream_player.queue_free()
