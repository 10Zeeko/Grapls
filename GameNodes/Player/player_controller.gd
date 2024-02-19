extends RigidBody2D

enum State {
	IDLE,
	WALK,
	JUMP,
	GRAPLING
}

var current_state = State.IDLE

# Player speed
var speed = 200
# Jump force
var jump_force = 300

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

func idle_state():
	# Code for idle state
	if Input.is_action_pressed('right') or Input.is_action_pressed('left'):
		current_state = State.WALK
	elif Input.is_action_just_pressed('jump'):
		current_state = State.JUMP

func walk_state():
	# Code for walk state
	var velocity = Vector2.ZERO

	if Input.is_action_pressed('right'):
		velocity.x += speed
	if Input.is_action_pressed('left'):
		velocity.x -= speed

	# Apply horizontal movement
	self.linear_velocity.x = velocity.x

	if Input.is_action_just_pressed('jump'):
		current_state = State.JUMP
	elif not Input.is_action_pressed('right') and not Input.is_action_pressed('left'):
		current_state = State.IDLE

func jump_state():
	# Code for jump state
	self.linear_velocity.y = -jump_force
	current_state = State.IDLE

func grapling_state():
	
