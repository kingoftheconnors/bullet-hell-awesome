extends CPUParticles2D

var target : Node2D = null

func start_orbit(orbiter):
	$Tween.interpolate_property(self, "orbit_velocity", 0, 0.1, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	target = orbiter
func stop_orbit():
	$Tween.interpolate_property(self, "orbit_velocity", 0.1, 0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	target = null

func flyby_stars():
	emission_rect_extents = Vector2.ONE
	initial_velocity = 100
	radial_accel = 100
	$Tween.interpolate_property(self, "lifetime", 10, 3, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	explosiveness = 0
func standstill_stars():
	emission_rect_extents = Vector2(256, 150)
	initial_velocity = 0
	radial_accel = 0
	$Tween.interpolate_property(self, "lifetime", 3, 30, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	explosiveness = 0.5

func _physics_process(delta):
	if target != null and is_instance_valid(target):
		self.global_position = target.global_position

func _input(event):
	if event is InputEventKey and event.is_action_pressed("ui_page_up"):
		flyby_stars()
	if event is InputEventKey and event.is_action_pressed("ui_page_down"):
		standstill_stars()
