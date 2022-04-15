extends KinematicBody2D

const SPEED = 120
const THIN = 0.75
onready var sprite = $Sprite
onready var particleEmitter = $Particles2D

func _physics_process(delta):
	var horizontal = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var vertical = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	
	if abs(horizontal) > abs(vertical):
		sprite.scale = Vector2(lerp(sprite.scale.x, 1, .1), lerp(sprite.scale.y, THIN, .1))
	if abs(vertical) > abs(horizontal):
		sprite.scale = Vector2(lerp(sprite.scale.x, THIN, .1), lerp(sprite.scale.y, 1, .1))
	else:
		sprite.scale = Vector2(lerp(sprite.scale.x, 1, .1), lerp(sprite.scale.y, 1, .1))
	if horizontal == 0 and vertical == 0:
		particleEmitter.initial_velocity = 0
	else:
		particleEmitter.direction = Vector2(-horizontal, -vertical)
		particleEmitter.initial_velocity = 10
	move_and_slide(Vector2(horizontal,vertical)*SPEED)
