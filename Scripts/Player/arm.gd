extends Node2D

@onready var rope = $Rope
var direction := Vector2(0, 0)
var tip := Vector2(0, 0)

const SPEED = 50

var flying = false
var hooked = false
var grappling_distance = 0.0

func shoot(dir: Vector2):
	direction = dir.normalized()
	flying = true
	tip = self.global_position

func release():
	flying = false
	hooked = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	self.visible = flying or hooked
	if not self.visible:
		return
	var tip_loc = to_local(tip)
	$Tip.rotation = self.position.angle_to_point(tip_loc) - deg_to_rad(90)
	rope.set_point_position(0, Vector2(0, 0))
	rope.set_point_position(1, tip_loc)
	
func _physics_process(delta):
	$Tip.global_position = tip
	if flying:
		if $Tip.move_and_collide(direction * SPEED):
			hooked = true
			flying = false
			grappling_distance = $Tip.position.distance_to(get_parent().get_parent().position)
		tip = $Tip.global_position
