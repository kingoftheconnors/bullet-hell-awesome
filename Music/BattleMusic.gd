extends AudioStreamPlayer

enum MUSIC {
	NONE,
	BATTLE,
	AMBIENCE,
}

var current_music = MUSIC.NONE

func play_battle_music():
	if current_music != MUSIC.BATTLE:
		stream = preload("res://Music/Bullet Hell demo2.wav")
		play()
	current_music = MUSIC.BATTLE

func play_ambience():
	if current_music != MUSIC.AMBIENCE:
		stream = preload("res://Music/Cutscene ambience.wav")
		play()
	current_music = MUSIC.AMBIENCE

func stop():
	.stop()
	current_music = MUSIC.NONE
