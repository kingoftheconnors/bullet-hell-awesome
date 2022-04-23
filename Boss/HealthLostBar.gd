extends TextureProgress

func wait():
	set_process(false)

func _process(delta):
	# Move yellow towards red
	if get_parent().value < value:
		value -= 1
	if get_parent().value > value:
		value = get_parent().value

func _on_Timer_timeout():
	set_process(true)
