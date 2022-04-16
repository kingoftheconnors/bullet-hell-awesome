extends Node

onready var container : Control = get_node("MarginContainer/HBoxContainer")
onready var progress : TextureProgress = get_node("MarginContainer/HBoxContainer/TextureProgress")
onready var label : Label = get_node("MarginContainer/HBoxContainer/Label")

func initialize(name, health):
	container.visible = true
	label.text = name
	progress.max_value = health
	progress.value = health

func damage() -> bool:
	progress.value -= 1
	if progress.value <= 0:
		container.visible = false
		return true
	return false
