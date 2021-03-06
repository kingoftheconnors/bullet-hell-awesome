extends Node

onready var container : Control = get_node("MarginContainer/VBoxContainer")
onready var container_animator = get_node("MarginContainer/VBoxContainer/AnimationPlayer")
onready var progress : TextureProgress = get_node("MarginContainer/VBoxContainer/HBoxContainer/TextureProgress")
onready var label : Label = get_node("MarginContainer/VBoxContainer/HBoxContainer/Label")

func initialize(name, health):
	label.text = name
	progress.set_health(health)

func show():
	container_animator.play("show")

func damage() -> bool:
	progress.damage()
	if progress.get_health() <= 0:
		container_animator.play("hide")
		boss_death()
		return true
	return false

func get_health() -> int:
	return progress.get_health()

var moons : Dictionary = {}
func boss_death():
	$DeathLight/BossKillAnimator.play("Die")
	yield(get_tree().create_timer(2), "timeout")
	for moon in moons.values():
		if is_instance_valid(moon):
			moon.queue_free()

var half_filled_healthrow : Node = null
func initialize_moon(name : String, health):
	if moons.has(name):
		if half_filled_healthrow == moons[name]:
			half_filled_healthrow = null
		moons[name].queue_free()
	var health_holder = preload("res://Boss/MoonHealthGui.tscn").instance()
	if half_filled_healthrow == null or !is_instance_valid(half_filled_healthrow):
		container.add_child(health_holder)
		half_filled_healthrow = health_holder
	else:
		health_holder.alignment = HALIGN_RIGHT
		half_filled_healthrow.add_child(health_holder)
		half_filled_healthrow = null
	health_holder.get_node("Label").text = name
	health_holder.get_node("TextureProgress").set_health(health)
	moons[name] = health_holder

func damage_moon(name : String) -> bool:
	if moons.has(name):
		var moon_progress = moons[name].get_node("TextureProgress")
		moon_progress.damage()
		if moon_progress.get_health() <= 0:
			return true
		return false
	else:
		return false

func heal_moon(moon : Node2D):
	if moons.has(moon):
		var moon_progress = moons[moon].get_node("TextureProgress")
		moon_progress.value += 1

func new_level():
	$DeathLight/BossKillAnimator.play("NewLevel")
func new_level_from_menu():
	$DeathLight/BossKillAnimator.play("NewLevel (to black and back)")
