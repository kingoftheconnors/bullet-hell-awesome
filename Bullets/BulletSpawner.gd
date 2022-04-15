extends Node2D

enum BulletType {
	BULLET
}

export(Vector2) var default_direction = Vector2.DOWN
export(float) var bulletsPerSecond = 1
export(BulletType) var bulletType = BulletType.BULLET
var timeSinceLastBullet : float = 0

func _process(delta):
	if bulletsPerSecond > 0:
		timeSinceLastBullet += delta
		if timeSinceLastBullet > (1/bulletsPerSecond):
			shoot()

# direction is a paramater that can be passed in, but if it isn't, it'll
# use the default_direction variable
func shoot(direction = default_direction):
	match bulletType:
		BulletType.BULLET:
			var bullet = preload("res://Bullets/Bullet.tscn").instance()
			bullet.position = self.position
			bullet.direction = direction
			get_parent().add_child(bullet)
	timeSinceLastBullet -= (1/bulletsPerSecond)
