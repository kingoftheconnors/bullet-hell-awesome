extends Node2D

func _ready():
	$AnimationPlayer.play("Created")

# Called when the node enters the scene tree for the first time.
func destroy():
	$CPUParticles2D.emitting = true
	$Sprite.visible = false
	yield(get_tree().create_timer(.5), "timeout")
	queue_free()

