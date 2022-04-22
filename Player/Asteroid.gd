extends Sprite

# Called when the node enters the scene tree for the first time.
func destroy():
	$CPUParticles2D.emitting = true
	yield(get_tree().create_timer(.5), "timeout")
	queue_free()

