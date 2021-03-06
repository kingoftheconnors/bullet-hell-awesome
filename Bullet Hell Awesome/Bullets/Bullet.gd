extends Area2D

var direction : Vector2 = Vector2.RIGHT
export(int) var SPEED = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = direction.angle()
	$DestructionTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction * delta * SPEED

func _on_Area2D_body_entered(body):
	if body.has_method("damage"):
		var damaged = body.damage()
		if damaged:
			queue_free()

# Long timer that ensures bullet is offscreen. Destroy bullet to save space
func _on_DestructionTimer_timeout():
	queue_free()
