tool
extends NinePatchRect

export(float) var width = 40
export(float) var height = 40

onready var left = $Colliders/Left
onready var right = $Colliders/Right
onready var top = $Colliders/Top
onready var bottom = $Colliders/Bottom

func _ready():
	resize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if width != rect_size.x or height != rect_size.y:
		resize()

func resize():
	rect_size = Vector2(width, height)
	rect_position = Vector2(-width/2, -height/2)
	# Move collision shapes
	left.position = Vector2(4, height/2)
	right.position = Vector2(width-4, height/2)
	top.position = Vector2(width/2, 4)
	bottom.position = Vector2(width/2, height-4)
	# Resize collision shapes
	left.shape.extents = Vector2(4, height/2)
	top.shape.extents = Vector2(width/2, 4)
