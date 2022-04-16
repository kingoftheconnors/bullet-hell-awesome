extends Node2D

const bullet_scene = preload("res://Bullets/Bullet.tscn")
onready var shoot_timer = $ShootTimer
onready var rotater = $Rotater

## Speed of bullet spawners spinning. Affects slope of spiral
export(int) var rotate_speed = 100
## Time between shots fired. Make this smaller to close
##the distance between bullets
export(float) var shoot_timer_wait_time = 0.1
## Number of spawners that will be spinning around the enemy.
## Increase this to have the spirals come closer together
export(int) var spawn_point_count = 4
## Distance from this node to where the bullets will be spawned.
export(int) var radius = 10

func start():
	shoot_timer.start()
func stop():
	shoot_timer.stop()


func _ready():
	var step = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = shoot_timer_wait_time

func _process(delta):
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)

func _on_ShootTimer_timeout() -> void:
	for s in rotater.get_children():
		var bullet = bullet_scene.instance()
		bullet.direction = Vector2(cos(s.global_rotation), sin(s.global_rotation))
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
