extends CanvasGroup

@onready var keyboard_a = $KeyboardAOutline
@onready var keyboard_d = $KeyboardDOutline
@onready var keyboard_space = $KeyboardSpaceOutline
@onready var space_timer = $SpaceTimer

var original_a
var original_d
var original_space

@export var pressed_a: Texture
@export var pressed_d: Texture
@export var pressed_space: Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	original_a = keyboard_a.texture
	original_d = keyboard_d.texture
	original_space = keyboard_space.texture
	
func _process(_delta):
	if Input.is_action_pressed('right'):
		keyboard_d.texture = pressed_d
	else:
		keyboard_d.texture = original_d
	if Input.is_action_pressed('left'):
		keyboard_a.texture = pressed_a
	else:
		keyboard_a.texture = original_a
	if Input.is_action_just_pressed('jump'):
		keyboard_space.texture = pressed_space
		space_timer.start()


func _on_space_timer_timeout():
	keyboard_space.texture = original_space
