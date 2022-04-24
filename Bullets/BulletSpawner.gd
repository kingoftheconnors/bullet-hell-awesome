extends Node2D

export(Vector2) var default_direction = Vector2.DOWN
export(float) var bulletsPerSecond = 1
export(float) var v_angle_step = 10
var timeSinceLastBullet : float = 0

func _process(delta):
	if bulletsPerSecond > 0:
		timeSinceLastBullet += delta
		if timeSinceLastBullet > (1/bulletsPerSecond):
			shoot()
			timeSinceLastBullet -= (1/bulletsPerSecond)

# direction is a paramater that can be passed in, but if it isn't, it'll
# use the default_direction variable
func shoot(direction : Vector2 = default_direction):
	var bullet = preload("res://Bullets/Bullet.tscn").instance()
	bullet.direction = direction
	get_tree().root.get_node("Level").add_child(bullet)
	bullet.global_position = self.global_position

func shoot_at_player():
	var player = get_tree().get_nodes_in_group("player")[0]
	var bullet = preload("res://Bullets/Flechette.tscn").instance()
	bullet.direction = (player.global_position - global_position).normalized()
	get_tree().root.get_node("Level").add_child(bullet)
	bullet.global_position = self.global_position

func shoot_v_at_player(num_shots : int):
	var player = get_tree().get_nodes_in_group("player")[0]
	for shotNum in range(num_shots):
		var bullet = preload("res://Bullets/Flechette.tscn").instance()
		var direction : Vector2 = (player.global_position - global_position).normalized()
		if shotNum % 2 == 0:
			var angle = direction.angle() + deg2rad(v_angle_step*shotNum/2)
			bullet.direction = Vector2(cos(angle), sin(angle))
		else:
			var angle = direction.angle() - deg2rad(v_angle_step*(shotNum+1)/2)
			bullet.direction = Vector2(cos(angle), sin(angle))
		get_tree().root.get_node("Level").add_child(bullet)
		bullet.global_position = self.global_position

func shoot_laser_beam_at_player():
	var player = get_tree().get_nodes_in_group("player")[0]
	var laser = preload("res://Bullets/Laser.tscn").instance()
	laser.direction = (player.global_position - global_position).normalized()
	add_child(laser)
	laser.shoot(true)
# direction is a paramater that can be passed in, but if it isn't, it'll
# use the default_direction variable
func shoot_laser_beam(direction : Vector2 = default_direction):
	var laser = preload("res://Bullets/Laser.tscn").instance()
	laser.direction = direction
	add_child(laser)
	laser.shoot(true)
func shoot_horizontal_beam_at_player():
	var player = get_tree().get_nodes_in_group("player")[0]
	var laser = preload("res://Bullets/Laser.tscn").instance()
	laser.direction = Vector2.RIGHT
	get_tree().root.get_node("Level").add_child(laser)
	laser.global_position = Vector2(-10,player.global_position.y)
	laser.shoot(true)
func shoot_vertical_beam_at_player():
	var player = get_tree().get_nodes_in_group("player")[0]
	var laser = preload("res://Bullets/Laser.tscn").instance()
	laser.direction = Vector2.DOWN
	get_tree().root.get_node("Level").add_child(laser)
	laser.global_position = Vector2(player.global_position.x,-10)
	laser.shoot(true)
