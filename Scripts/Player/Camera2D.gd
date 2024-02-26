extends Camera2D

const DEAD_ZONE = 300
@export var DISTANCE = 0.3

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		var _target = event.position - get_viewport_rect(). size * 0.5
		if _target.length() < DEAD_ZONE:
			self.position = Vector2(0,0)
		else:
			self.position = _target.normalized() * (_target.length() - DEAD_ZONE) * DISTANCE
		
