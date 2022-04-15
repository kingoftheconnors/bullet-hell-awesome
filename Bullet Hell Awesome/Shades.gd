extends KinematicBody2D

const SPEED = 120
const THIN = 0.75
onready var sprite = $Sprite
onready var particleEmitter = $Particles2D

#func _physics_process(delta):
#	var shadehorizontal = 1
#	var shadevertical = 1
#	move_and_slide(Vector2(shadehorizontal,shadevertical)*SPEED)
