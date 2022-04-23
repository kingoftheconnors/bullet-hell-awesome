extends Node

# Declare member variables here. Examples:
var tags : Dictionary = {}

func set_tag(name, value):
	tags[name] = value
func get_tag(name):
	if tags.has(name):
		return tags[name]
	else:
		return null
