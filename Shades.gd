extends KinematicBody2D

const SPEED = 120
const THIN = 0.75
onready var sprite = $Sprite
onready var particleEmitter = $Particles2D
export(int, 0, 100) var orbit_radius = 95
export(int, 0, 500) var health = 50
export(String) var bossName = "Boss Name"
export(NodePath) var deathText
var dying = false

func _ready():
	BossHealthGui.initialize(bossName, health)

func start(_skip):
	$AnimationTree.active = true
	BossHealthGui.show()

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
			emit_signal("dead")
			# TODO: Play boss death sfx
			BattleMusic.stop()
			yield(get_tree().create_timer(2), "timeout")
			BattleMusic.play_ambience()
			get_tree().get_nodes_in_group("player")[0].stop()
			get_node(deathText).start()
		else:
			emit_signal("damage", BossHealthGui.get_health())
	return true

func _on_ColliderDamage_body_entered(body):
	if body.has_method("damage"):
		body.damage()

signal orbitting
signal dead
signal damage
