extends Sprite

export(int) var delay_frames = 1
export(NodePath) var following
onready var following_body : Node2D = get_node(following)

var previous_positions = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	previous_positions.append(following_body.position)
	if previous_positions.size() > delay_frames:
		position = previous_positions.pop_front()
