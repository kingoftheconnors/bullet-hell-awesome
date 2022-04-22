extends HBoxContainer

export(bool) var first_box = false
export(String) var text = "Hello there"
export(String) var color = "red"
export(NodePath) var nextBox
var active = false

onready var animator = $VBoxContainer/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if first_box:
		start()

func start():
	$VBoxContainer/RichTextLabel.append_bbcode(
		"[center][color=" + color + "]" + text + "[/color]")
	animator.play("showBox")
	active = true

func _input(event):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
			if animator.current_animation_position < animator.current_animation_length:
				animator.advance(animator.current_animation_length - animator.current_animation_position)
			else:
				emit_signal("next_box")
				if not nextBox.is_empty():
					get_node(nextBox).start()
				queue_free()

signal next_box
