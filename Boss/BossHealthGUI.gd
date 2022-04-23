extends Node

onready var container : Control = get_node("MarginContainer/VBoxContainer")
onready var progress : TextureProgress = get_node("MarginContainer/VBoxContainer/HBoxContainer/TextureProgress")
onready var label : Label = get_node("MarginContainer/VBoxContainer/HBoxContainer/Label")

func initialize(name, health):
	container.visible = true
	label.text = name
	progress.max_value = health
	progress.value = health

func damage() -> bool:
	progress.value -= 1
	if progress.value <= 0:
		container.visible = false
		boss_death()
		return true
	return false

var moons : Dictionary = {}
func boss_death():
	$DeathLight/BossKillAnimator.play("Die")
	yield(get_tree().create_timer(2), "timeout")
	for moon in moons.values():
		moon.queue_free()

var half_filled_healthrow : Node = null
func initialize_moon(name : String, health):
	if moons.has(name):
		moons[name].queue_free()
	var health_holder = preload("res://Boss/MoonHealthGui.tscn").instance()
	health_holder.get_node("Label").text = name
	health_holder.get_node("TextureProgress").max_value = health
	health_holder.get_node("TextureProgress").value = health
	if half_filled_healthrow == null:
		container.add_child(health_holder)
		half_filled_healthrow = health_holder
	else:
		health_holder.alignment = HALIGN_RIGHT
		half_filled_healthrow.add_child(health_holder)
		half_filled_healthrow = null
	moons[name] = health_holder

func damage_moon(name : String) -> bool:
	if moons.has(name):
		var moon_progress = moons[name].get_node("TextureProgress")
		moon_progress.value -= 1
		if moon_progress.value <= 0:
			return true
		return false
	else:
		return false

func heal_moon(moon : Node2D):
	if moons.has(moon):
		var moon_progress = moons[moon].get_node("TextureProgress")
		moon_progress.value += 1
