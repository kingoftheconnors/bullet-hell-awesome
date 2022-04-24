extends Button

func _on_Button_pressed():
	print("Starting")
	BossHealthGui.new_level_from_menu()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Terra.tscn")
