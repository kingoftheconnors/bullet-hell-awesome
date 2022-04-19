extends KinematicBody2D

const SPEED = 120
const THIN = 0.65
onready var sprite = $Sprite
onready var particleEmitter = $Particles2D
onready var asteroids = $Asteroids
const NUM_ASTEROIDS = 2
const HEAL_TIME_AFTER_DAMAGE = 5
const HEAL_TIME_AFTER_FIRST_HEAL = 2

var shooting : bool = false
const TIME_BETWEEN_BULLETS = 0.15
var timeSinceLastBullet : float = 0

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
	
	if shooting:
		timeSinceLastBullet += delta
		if timeSinceLastBullet > TIME_BETWEEN_BULLETS:
			var bullet = preload("res://Bullets/PlayerBullet.tscn").instance()
			bullet.direction = (get_global_mouse_position() - self.global_position).normalized()
			get_tree().root.add_child(bullet)
			bullet.global_position = self.global_position
			timeSinceLastBullet = 0

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
