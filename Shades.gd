extends KinematicBody2D

const SPEED = 120
const THIN = 0.75
onready var sprite = $Sprite
onready var particleEmitter = $Particles2D
export(int, 0, 500) var health = 50
export(String) var bossName = "Boss Name"
var dying = false

func _ready():
	BossHealthGui.initialize(bossName, health)

func start(_skip):
	$AnimationTree.active = true

func start_orbit():
	get_tree().call_group("orbiter", "start_orbit", self)
func stop_orbit():
	get_tree().call_group("orbiter", "stop_orbit")

#func _physics_process(delta):
#	var shadehorizontal = 1
#	var shadevertical = 1
#	move_and_slide(Vector2(shadehorizontal,shadevertical)*SPEED)

# Damage function. Returns true if bullet that hits it should be removed
func damage() -> bool:
	if !dying:
		dying = BossHealthGui.damage()
		if dying:
			TagManager.set_tag(owner.filename + "-bossDead", true)
			$AnimationTree.active = false
	return true

signal orbitting
