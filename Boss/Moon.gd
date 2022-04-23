extends KinematicBody2D

enum MOVEMENT_MODE {
	ORBIT,
	#BLOCK,
	CHASE
}
export(MOVEMENT_MODE) var movementMode = MOVEMENT_MODE.ORBIT

export(int) var speed = 180
onready var sprite = $Sprite
onready var particleEmitter = $Particles2D
const HEAL_TIME_AFTER_DAMAGE = 3
const HEAL_TIME_AFTER_FIRST_HEAL = 0.5

const ORBIT_TURNAROUND_TIME = 550
export(NodePath) var planet
onready var orbitting_body : Node2D = get_node(planet)
onready var orbit_radius = self.position.length()
const ORBIT_RADIUS_SPEED = 15

export(int) var health = 50
export(String) var moon_name = "Moon"

func _ready():
	BossHealthGui.initialize_moon(moon_name, health)

onready var tween = $Tween
func start_orbit(orbitting_body):
	movementMode = MOVEMENT_MODE.CHASE
	tween.stop_all()
	tween.interpolate_property(self, "speed", 180, 120, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
func stop_orbit():
	movementMode = MOVEMENT_MODE.ORBIT
	tween.interpolate_property(self, "speed", 120, 180, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)

# Damage function. Returns true if bullet that hits it should be removed
func damage() -> bool:
	var dead = BossHealthGui.damage_moon(moon_name)
	# TODO: Die
	if dead:
		queue_free()
	else:
		$HealTimer.start(HEAL_TIME_AFTER_DAMAGE)
	return true

func _physics_process(delta):
	if not is_instance_valid(orbitting_body):
		return
	# Chase planet
	var direction := Vector2.ZERO
	var radius_direction := Vector2.ZERO
	if movementMode == MOVEMENT_MODE.ORBIT:
		# Moving along orbit
		direction = get_orbit_vector_in_horizontal(1)
		if (orbitting_body.global_position - self.global_position).length() > orbit_radius + 5 \
			or (orbitting_body.global_position - self.global_position).length() < orbit_radius - 5:
			radius_direction = (orbitting_body.global_position - self.global_position).normalized()
	elif movementMode == MOVEMENT_MODE.CHASE:
		# Move towards player on up-down angle
		var player = get_tree().get_nodes_in_group("player")[0]
		var player_radius = (player.global_position - orbitting_body.global_position).length()
		var moon_radius = (self.global_position - orbitting_body.global_position).length()
		if abs(player_radius - moon_radius) > 4:
			if moon_radius > player_radius:
				radius_direction = (orbitting_body.global_position - self.global_position).normalized()
			else:
				radius_direction = -(orbitting_body.global_position - self.global_position).normalized()
		direction = get_orbit_vector_in_horizontal(1)
	# Particles
	if direction == Vector2.ZERO:
		particleEmitter.initial_velocity = 0
	else:
		particleEmitter.direction = Vector2(-direction.x, -direction.y)
		particleEmitter.initial_velocity = 10
	move_and_slide(direction*speed)
	move_and_slide(radius_direction * ORBIT_RADIUS_SPEED)

func get_orbit_vector_in_horizontal(this_horizontal : float) -> Vector2:
	var current_angle = self.global_position.angle_to_point(orbitting_body.global_position)
	return Vector2(sin(current_angle) * this_horizontal, -cos(current_angle) * this_horizontal)

func _on_HealTimer_timeout():
	BossHealthGui.heal_moon(self)
	$HealTimer.start(HEAL_TIME_AFTER_FIRST_HEAL)

func _on_Collider_body_entered(body):
	if body != self and body.has_method("damage"):
		body.damage()
