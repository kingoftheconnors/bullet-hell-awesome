extends Node2D

## Speed of bullet spawners spinning. Affects slope of spiral
export(int) var rotate_speed = 100
## Distance from this node to where the bullets will be spawned.
export(int) var radius = 10

func _process(delta):
	var new_rotation = rotation_degrees + rotate_speed * delta
	rotation_degrees = fmod(new_rotation, 360)

func reset_asteroid_rotations():
	var num_asteroids = get_num_asteroids()
	if num_asteroids > 0:
		var step = 2 * PI / num_asteroids
		for i in range(num_asteroids):
			var asteroid = get_child(i)
			var pos = Vector2(radius, 0).rotated(step * i)
			asteroid.position = pos
			asteroid.rotation = pos.angle()

func add_asteroid():
	add_child(preload("res://Player/Asteroid.tscn").instance())
	reset_asteroid_rotations()
func remove_asteroid() -> int:
	if get_num_asteroids() > 0:
		get_child(0).destroy()
		reset_asteroid_rotations()
	return get_num_asteroids()
func get_num_asteroids() -> int:
	return get_child_count()
