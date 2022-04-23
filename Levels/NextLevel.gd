extends Node

export(String) var level_name = "res://MainMenu/MainMenu.tscn"

func start(_skip = false):
	BossHealthGui.new_level()
	get_tree().change_scene_to(load(level_name))
