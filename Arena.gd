tool
extends NinePatchRect

export(float) var left = -20
export(float) var top = -20
export(float) var right = 20
export(float) var bottom = 20

onready var leftCollider = $Colliders/Left
onready var rightCollider = $Colliders/Right
onready var topCollider = $Colliders/Top
onready var bottomCollider = $Colliders/Bottom

func _ready():
	resize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if left != rect_position.x or top != rect_position.y \
		or right-left != rect_size.x or bottom-top != rect_size.y:
		resize()

func resize():
	var height = bottom-top
	var width = right-left
	rect_size = Vector2(width, height)
	rect_position = Vector2(left, top)
	# Move collision shapes
	leftCollider.position = Vector2(4, height/2)
	rightCollider.position = Vector2(width-4, height/2)
	topCollider.position = Vector2(width/2, 4)
	bottomCollider.position = Vector2(width/2, height-4)
	# Resize collision shapes
	leftCollider.shape.extents = Vector2(4, height/2)
	topCollider.shape.extents = Vector2(width/2, 4)
