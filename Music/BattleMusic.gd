extends AudioStreamPlayer

enum MUSIC {
	BATTLE,
	AMBIENCE,
	NONE,
}

var current_music = MUSIC.NONE

func play_battle_music():
	stream = preload("res://Music/Bullet Hell demo2.wav")
	if current_music != MUSIC.BATTLE:
		play()
	current_music = MUSIC.BATTLE

func play_ambience():
	stream = preload("res://Music/Cutscene ambience.wav")
	if current_music != MUSIC.AMBIENCE:
		play()
	current_music = MUSIC.AMBIENCE

func stop():
	.stop()
	current_music = MUSIC.NONE
