extends RigidBody2D

@onready var arm = $Arm
@onready var circle_collision = $CircleCollision
@export var spring: PinJoint2D
@onready var canvas_layer = $CanvasLayer
@onready var left_hand = $CanvasLayer/LeftHand
@onready var right_hand = $CanvasLayer/RightHand
@onready var hud = $CanvasLayer/Camera2D/HUD
@onready var player_face = $CanvasLayer/Face
@export var game_over : String
@onready var jump_audio = $JumpAudio
@onready var ray_cast_2d = $RayCast2D

signal update_lives(lives: int)

enum State {
	IDLE,
	WALK,
	JUMP,
	GRAPLING,
	HOOKED,
	THROW
}

var current_state = State.IDLE
var spawn_point = Vector2(0, -55)

# Player
var speed = 200

#Player Face
var happy_face: Texture2D
@export var speed_face: Texture2D
var speed_change = 550

# Jump force
var jump_force = 300
var speed_limit = 200
var hook_speed_limit = 700

# Hook
var hook_force = 10

func _ready():
	happy_face = player_face.texture

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

	spring.position = $Arm/Tip/StaticBody2D.global_position
	canvas_layer.position = self.position
	
	player_fall()

func idle_state():
	if Input.is_action_pressed('right') or Input.is_action_pressed('left'):
		current_state = State.WALK
	elif Input.is_action_just_pressed('jump') and is_on_ground():
		print("Jumping from IDLE")
		current_state = State.JUMP
		jump_audio.play()
	elif arm.hooked:
		current_state = State.GRAPLING

func walk_state():
	var velocity = Vector2.ZERO

	if Input.is_action_pressed('right'):
		velocity.x += speed
	if Input.is_action_pressed('left'):
		velocity.x -= speed

	if self.linear_velocity.x <= speed_limit or self.linear_velocity.x >= speed_limit:
		self.linear_velocity.x = velocity.x

	if Input.is_action_just_pressed('jump') and is_on_ground():
		print("Jumping from WALK")
		current_state = State.JUMP
		jump_audio.play()
	elif not Input.is_action_pressed('right') and not Input.is_action_pressed('left'):
		current_state = State.IDLE
	elif arm.hooked:
		current_state = State.GRAPLING

func jump_state():
	print("In JUMP state")
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
		if Input.is_action_pressed('right'):
			self.apply_central_impulse(Vector2(hook_force, 0))
		elif Input.is_action_pressed('left'):
			self.apply_central_impulse(Vector2(-hook_force, 0))
	if abs(linear_velocity.x) > speed_change or abs(linear_velocity.y) > speed_change:
		player_face.texture = speed_face
	else:
		player_face.texture = happy_face

func throw_state():
	if Input.is_action_pressed('right'):
		self.apply_central_impulse(Vector2(hook_force, 0))
	elif Input.is_action_pressed('left'):
		self.apply_central_impulse(Vector2(-hook_force, 0))
	if arm.hooked:
		current_state = State.GRAPLING
	if abs(linear_velocity.x) > speed_change or abs(linear_velocity.y) > speed_change:
		player_face.texture = speed_face
	else:
		player_face.texture = happy_face
		
func player_fall():
	if self.position[1] > 700:
		restart_player()
		
func restart_player():
	self.position = spawn_point
	self.linear_velocity = Vector2.ZERO
	PlayerStats.player_lives -= 1
	if PlayerStats.player_lives <= 0:
		get_tree().change_scene_to_file(game_over)
	update_lives.emit(PlayerStats.player_lives)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and current_state != State.HOOKED:
			var mouse_pos = Vector2(event.global_position.x, event.global_position.y)
			var viewport_size = Vector2(get_viewport().size.x, get_viewport().size.y)
			var game_size = Vector2(1080, 720)
			var adjusted_mouse_pos = mouse_pos - (viewport_size - game_size) / 2
			var evShoot = adjusted_mouse_pos - game_size * 0.5
			arm.shoot(evShoot)
			if evShoot.normalized()[0] > 0:
				left_hand.visible = false
			else:
				right_hand.visible = false
		else:
			arm.release()
			right_hand.visible = true
			left_hand.visible = true

func add_lives():
	PlayerStats.player_lives += 1
	update_lives.emit(PlayerStats.player_lives)

func update_spawn(pos):
	spawn_point = pos

func is_on_ground() -> bool:
	var on_ground = ray_cast_2d.is_colliding()
	print("Is on ground: ", on_ground)
	return on_ground

func _on_body_entered(body) -> void:
	if current_state == State.THROW:
		current_state = State.IDLE
		player_face.texture = happy_face
