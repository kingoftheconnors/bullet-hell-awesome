extends Label

func _on_Area2D_body_entered(body):
	text = "Hold Left-Click\nto Shoot"
	get_node("../OrbitArea/StaticBody2D/CPUParticles2D").emitting = true
