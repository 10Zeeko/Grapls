extends CharacterBody2D

const SPEED = 600.0
const MAX_SPEED = 1000
const JUMP_VELOCITY = -400.0
const GRAVITY = 50
const FRICTION_AIR = 0.95
const FRICTION_GROUND = 0.85
const ARM_PULL = 100

var arm_velocity = Vector2(0, 0)
var can_jump = false

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			$Arm.shoot(event.position - get_viewport().size * 0.5)
		else:
			$Arm.release()

func _physics_process(delta):
	var move = (Input.get_action_strength("right") - Input.get_action_strength("left")) * SPEED
	
	velocity.y += GRAVITY
	
	if $Arm.hooked:
		var direction = 0
		if Input.is_action_pressed("up"):
			direction = 1
			$Arm.grappling_distance -= 5  # Decrease the grappling distance
		elif Input.is_action_pressed("down"):
			direction = -1
			$Arm.grappling_distance += 5  # Increase the grappling distance
		arm_velocity = to_local($Arm.tip).normalized() * ARM_PULL * direction
		if arm_velocity.y > 0:
			arm_velocity.y *= 0.55
		else:
			arm_velocity.y *= 1.65
		if sign(arm_velocity.x) != sign(move):
			arm_velocity *= 0.7
		# Limit the distance between the player and the grappling hook
		var distance = position.distance_to($Arm.tip)
		if distance > $Arm.grappling_distance:
			var direction_to_hook = ($Arm.tip - position).normalized()
			position += direction_to_hook * (distance - $Arm.grappling_distance)
			# Apply a force that simulates the tension of the rope
			var angle = ($Arm.tip - position).angle_to(Vector2.UP)
			var tension = GRAVITY * cos(angle)
			velocity += tension * direction_to_hook
	else:
		arm_velocity = Vector2(0, 0)
	velocity += arm_velocity
	
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
		if grounded and can_jump:
			can_jump = false
			velocity.y = JUMP_VELOCITY
