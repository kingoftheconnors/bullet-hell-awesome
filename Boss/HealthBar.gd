extends TextureProgress

onready var health_lost_bar = $HealthLostBar
onready var health_lost_timer = $Timer

func set_health(health : int):
	max_value = health
	value = health
	health_lost_bar.max_value = health
	health_lost_bar.value = health

func get_health():
	return value

func damage():
	value -= 1
	health_lost_bar.wait()
	health_lost_timer.start()
