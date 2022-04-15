extends Node2D

export(Vector2) var default_direction = Vector2.DOWN
export(float) var bulletsPerSecond = 1
var timeSinceLastBullet : float = 0

func _process(delta):
	if bulletsPerSecond > 0:
		timeSinceLastBullet += delta
		if timeSinceLastBullet > (1/bulletsPerSecond):
			shoot()
			timeSinceLastBullet -= (1/bulletsPerSecond)

# direction is a paramater that can be passed in, but if it isn't, it'll
# use the default_direction variable
func shoot(direction = default_direction):
	var bullet = preload("res://Bullets/Bullet.tscn").instance()
	bullet.direction = direction
	get_tree().root.get_node("Level").add_child(bullet)
	bullet.global_position = self.global_position

func shoot_at_player():
	var player = get_tree().root.get_node("Level/Player")
	var bullet = preload("res://Bullets/Flechette.tscn").instance()
	bullet.direction = (player.global_position - global_position).normalized()
	get_tree().root.get_node("Level").add_child(bullet)
	bullet.global_position = self.global_position
