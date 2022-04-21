extends KinematicBody2D

const SPEED = 120
const THIN = 0.75
onready var sprite = $Sprite
onready var particleEmitter = $Particles2D
export(int, 0, 500) var health = 50
export(String) var bossName = "Boss Name"

func _ready():
	BossHealthGui.initialize(bossName, health)

#func _physics_process(delta):
#	var shadehorizontal = 1
#	var shadevertical = 1
#	move_and_slide(Vector2(shadehorizontal,shadevertical)*SPEED)

# Damage function. Returns true if bullet that hits it should be removed
func damage() -> bool:
	var dead = BossHealthGui.damage()
	# TODO: Die
	if dead:
		queue_free()
	return true
