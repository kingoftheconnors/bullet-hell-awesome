extends KinematicBody2D

const SPEED = 120
onready var sprite = $Sprite
onready var particleEmitter = $Particles2D

func _physics_process(delta):
	var horizontal = 0
	var vertical = 0
	if global_position.y > 204:
		vertical = -1
	else:
		vertical = 0
	move_and_slide(Vector2(horizontal,vertical)*SPEED)
