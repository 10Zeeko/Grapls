extends Area2D

var flag_update = true
@onready var sprite_2d = $Sprite2D
@onready var gpu_particles_2d = $GPUParticles2D

func _on_body_entered(body):
	if (body.is_in_group("player")):
		body.update_spawn(position)
		gpu_particles_2d.emitting = true


func _on_timer_timeout():
	if flag_update:
		flag_update = false
		sprite_2d.frame += 1
	else:
		flag_update = true
		sprite_2d.frame -= 1
