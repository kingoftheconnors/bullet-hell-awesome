extends Area2D

var direction : Vector2 = Vector2.RIGHT
export(int) var SPEED = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = direction.angle()

func _on_Area2D_body_entered(body):
	if body.has_method("damage"):
		var damaged = body.damage()

# Default value of false.
# Just calling shoot() will let laser stay to be reused
func shoot(destroy_after_end = false):
	$Laser/AnimationPlayer.play("Blast")
	if destroy_after_end:
		yield(get_tree().create_timer(3), "timeout")
		queue_free()
