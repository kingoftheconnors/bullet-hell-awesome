extends Node

func initialize():
	$AnimationPlayer.play("Open")

func _on_Restart_pressed():
	$AnimationPlayer.play("Close")
	get_tree().reload_current_scene()

func _on_Quit_pressed():
	get_tree().quit()
