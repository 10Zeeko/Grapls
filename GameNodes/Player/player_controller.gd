extends RigidBody2D

@onready var arm = $Arm
@onready var circle_collision = $CircleCollision
@export var spring: PinJoint2D
@onready var canvas_layer = $CanvasLayer
@onready var left_hand = $CanvasLayer/LeftHand
@onready var right_hand = $CanvasLayer/RightHand

enum State {
	IDLE,
	WALK,
	JUMP,
	GRAPLING,
	HOOKED,
	THROW
}

var current_state = State.IDLE

# Player speed
var speed = 200

# Jump force
var jump_force = 300
var speed_limit = 200
var hook_speed_limit = 500

# Hook
var hook_force = 10

func _physics_process(delta):
	match current_state:
		State.IDLE:
			idle_state()
		State.WALK:
			walk_state()
		State.JUMP:
			jump_state()
		State.GRAPLING:
			grapling_state()
		State.HOOKED:
			hooked_state()
		State.THROW:
			throw_state()
	#print (current_state)
	spring.position = $Arm/Tip/StaticBody2D.global_position
	canvas_layer.position = self.position

func idle_state():
	# Code for idle state
	if Input.is_action_pressed('right') or Input.is_action_pressed('left'):
		current_state = State.WALK
	elif Input.is_action_just_pressed('jump'):
		current_state = State.JUMP
	elif arm.hooked:
		current_state = State.GRAPLING

func walk_state():
	# Code for walk state
	var velocity = Vector2.ZERO

	if Input.is_action_pressed('right'):
		velocity.x += speed
	if Input.is_action_pressed('left'):
		velocity.x -= speed

	# Apply horizontal movement
	if self.linear_velocity.x <= speed_limit or self.linear_velocity.x >= speed_limit:
		self.linear_velocity.x = velocity.x

	if Input.is_action_just_pressed('jump'):
		current_state = State.JUMP
	elif not Input.is_action_pressed('right') and not Input.is_action_pressed('left'):
		current_state = State.IDLE
	elif arm.hooked:
		current_state = State.GRAPLING

func jump_state():
	# Code for jump state
	self.linear_velocity.y = -jump_force
	current_state = State.IDLE

func grapling_state():
	spring.node_a = $Arm/Tip/StaticBody2D.get_path()
	spring.node_b = self.get_path()
	
	current_state = State.HOOKED
	
func hooked_state():
	spring.look_at($Arm/Tip/StaticBody2D.global_position)
	spring.rotation_degrees -= 90
	if not arm.hooked:
		spring.node_a = NodePath()
		spring.node_b = NodePath()
		current_state = State.THROW
		arm.hooked = false
	else:
		# Check the direction of movement
		if Input.is_action_pressed('right'):
			# Apply additional force to the right
			self.apply_central_impulse(Vector2(hook_force, 0))
		elif Input.is_action_pressed('left'):
			# Apply additional force to the left
			self.apply_central_impulse(Vector2(-hook_force, 0))
			
func throw_state():
	if Input.is_action_pressed('right'):
		# Apply additional force to the right
		self.apply_central_impulse(Vector2(hook_force, 0))
	elif Input.is_action_pressed('left'):
		# Apply additional force to the left
		self.apply_central_impulse(Vector2(-hook_force, 0))
	if  arm.hooked:
		current_state = State.GRAPLING
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var evShoot = event.position - get_viewport().size * 0.5
			arm.shoot(evShoot)
			if evShoot.normalized()[0] > 0:
				left_hand.visible = false
			else:
				right_hand.visible = false
		else:
			arm.release()
			right_hand.visible = true
			left_hand.visible = true


func _on_body_entered(body) -> void:
	if current_state == State.THROW:
		current_state = State.WALK
