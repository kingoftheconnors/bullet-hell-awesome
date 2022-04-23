extends Node

func start(_skip):
	if !BattleMusic.playing:
		BattleMusic.playing = true

func stop():
	BattleMusic.playing = false
