extends Node2D
@onready var rigid_body_2d = $RigidBody2D
@onready var static_body_2d = $StaticBody2D

@onready var pin_joint_2d = $PinJoint2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("click"):
		rigid_body_2d.apply_central_impulse(Vector2(20, 0))
		print("A")
