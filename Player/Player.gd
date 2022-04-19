extends KinematicBody2D

enum MOVEMENT_MODE {
	REGULAR,
	ORBIT
}
export(MOVEMENT_MODE) var movementMode = MOVEMENT_MODE.REGULAR

const SPEED = 120
const THIN = 0.65
onready var sprite = $Sprite
onready var particleEmitter = $Particles2D
onready var asteroids = $Asteroids
const NUM_ASTEROIDS = 2
const HEAL_TIME_AFTER_DAMAGE = 9
const HEAL_TIME_AFTER_FIRST_HEAL = 4

var shooting : bool = false
const TIME_BETWEEN_BULLETS = 0.15
var timeSinceLastBullet : float = 0

const MAX_ORBIT_DISTANCE = 75
const ORBIT_TURNAROUND_TIME = 750
var orbitting_body : Node2D
var orbitting_cur_direction : int = 1
var orbitting_input_strength : float = 0
var orbitting_time_of_last_h_input : int = 0

func start_orbit():
	var nodes = get_tree().get_nodes_in_group("Boss")
	if nodes.size() > 0:
		orbitting_body = nodes[0]
		movementMode = MOVEMENT_MODE.ORBIT
func stop_orbit():
	movementMode = MOVEMENT_MODE.REGULAR

onready var invincibilityAnimator = $AnimationTree
export(bool) var invincible = false
func damage() -> bool:
	if !invincible:
		asteroids.remove_asteroid()
		invincibilityAnimator['parameters/playback'].travel("Invincible")
		$HealTimer.start(HEAL_TIME_AFTER_DAMAGE)
		if asteroids.get_num_asteroids() == 0:
			# TODO: Die
			print("DEAD")
		return true
	return false

func _physics_process(delta):
	var horizontal : float; var vertical : float
	if movementMode == MOVEMENT_MODE.REGULAR:
		horizontal = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
		vertical = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
		if abs(horizontal) > abs(vertical):
			sprite.scale = Vector2(lerp(sprite.scale.x, 1, .1), lerp(sprite.scale.y, THIN, .1))
		if abs(vertical) > abs(horizontal):
			sprite.scale = Vector2(lerp(sprite.scale.x, THIN, .1), lerp(sprite.scale.y, 1, .1))
		else:
			sprite.scale = Vector2(lerp(sprite.scale.x, 1, .1), lerp(sprite.scale.y, 1, .1))
	elif movementMode == MOVEMENT_MODE.ORBIT:
		# Moving towards or away from planet
		move_and_slide((orbitting_body.position - self.position).normalized() * SPEED * Input.get_action_strength("ui_down"))
		if self.position.distance_to(orbitting_body.position) < MAX_ORBIT_DISTANCE:
			move_and_slide((orbitting_body.position - self.position).normalized() * SPEED * -Input.get_action_strength("ui_up"))
		else:
			# Force move towards planet
			move_and_slide((orbitting_body.position - self.position).normalized() * SPEED)
		# Moving along orbit
		var current_angle = self.global_position.angle_to_point(orbitting_body.global_position)
		# Player left/right
		var this_horizontal = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
		# If time is close enough to previous key-release, use old keys to decide direction
		if OS.get_ticks_msec() - orbitting_time_of_last_h_input > ORBIT_TURNAROUND_TIME:
			if this_horizontal != 0:
				print("Setting new direction")
				# If player wants to go right BELOW orbit object, go counterclockwise
				if (self.global_position.y > orbitting_body.global_position.y):
					orbitting_cur_direction = 1
				else:
					orbitting_cur_direction = -1
		# Set orbitting_time_of_last_h_input
		if this_horizontal != 0:
			orbitting_time_of_last_h_input = OS.get_ticks_msec() 
		orbitting_input_strength = orbitting_cur_direction * this_horizontal
		horizontal = sin(current_angle) * orbitting_input_strength
		vertical = -cos(current_angle) * orbitting_input_strength
	
	if horizontal == 0 and vertical == 0:
		particleEmitter.initial_velocity = 0
	else:
		particleEmitter.direction = Vector2(-horizontal, -vertical)
		particleEmitter.initial_velocity = 10
	move_and_slide(Vector2(horizontal,vertical)*SPEED)
	
	if shooting:
		timeSinceLastBullet += delta
		if timeSinceLastBullet > TIME_BETWEEN_BULLETS:
			var bullet = preload("res://Bullets/PlayerBullet.tscn").instance()
			bullet.direction = (get_global_mouse_position() - self.global_position).normalized()
			get_tree().root.add_child(bullet)
			bullet.global_position = self.global_position
			timeSinceLastBullet = 0

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			shooting = true
		else:
			shooting = false
			timeSinceLastBullet = 0

func _on_HealTimer_timeout():
	if asteroids.get_num_asteroids() < NUM_ASTEROIDS:
		asteroids.add_asteroid()
		$HealTimer.start(HEAL_TIME_AFTER_FIRST_HEAL)

func _ready():
	for i in range(NUM_ASTEROIDS):
		asteroids.add_asteroid()
