extends HBoxContainer

export(bool) var first_box = false
export(String) var text = "Hello there"
export(String) var color = "red"
export(Array, NodePath) var nextBox
var active = false

onready var animator = $VBoxContainer/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if first_box:
		if TagManager.get_tag(owner.filename) == true:
			start(true)
		else:
			start()
			BattleMusic.play_ambience()
			TagManager.set_tag(owner.filename, true)

func start(skip = false):
	if skip:
		end(skip)
		return
	$VBoxContainer/RichTextLabel.append_bbcode(
		"[center][color=" + color + "]" + text + "[/color]")
	animator.playback_speed = 20.0/text.length()
	animator.play("showBox")
	active = true

func _input(event):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
			if animator.current_animation_position < animator.current_animation_length:
				animator.advance((animator.current_animation_length - animator.current_animation_position)*text.length())
			else:
				end()

func end(skip = false):
	emit_signal("next_box")
	for i in nextBox:
		get_node(i).start(skip)
	queue_free()

signal next_box
