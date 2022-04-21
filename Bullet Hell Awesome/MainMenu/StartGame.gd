extends Button

func _on_Button_pressed():
	print("Starting")
	$AnimationPlayer.play("FadeToBlack")
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://test.tscn")
