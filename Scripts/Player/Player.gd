extends CharacterBody2D


const SPEED = 300.0
const MAX_SPEED = 1000
const JUMP_VELOCITY = -400.0
const GRAVITY = 50
const FRICTION_AIR = 0.95
const FRICTION_GROUND = 0.85

var can_jump = false

func _physics_process(delta):
	var move = (Input.get_action_strength("right") - Input.get_action_strength("left")) * SPEED
	
	velocity.y += GRAVITY
	
	velocity.x += move
	move_and_slide()
	velocity.x -= move
	
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	var grounded = is_on_floor()
	if grounded:
		velocity.x *= FRICTION_GROUND
		can_jump = true
		if (velocity.y >= 5):
			velocity.y = 5
	elif is_on_ceiling() and velocity.y <= -5:
		velocity.y = -5
		
	if Input.is_action_just_pressed("jump"):
		print ("TONTO")
		print (grounded)
		print (can_jump)
		if grounded and can_jump:
			velocity.y = JUMP_VELOCITY
