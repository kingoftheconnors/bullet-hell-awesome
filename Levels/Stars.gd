extends CPUParticles2D

var target : Node2D = null

func start_orbit(orbiter):
	$Tween.stop_all()
	$Tween.interpolate_property(self, "orbit_velocity", 0, 0.1, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	target = orbiter
func stop_orbit():
	$Tween.stop_all()
	$Tween.interpolate_property(self, "orbit_velocity", 0.1, 0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	target = null

func _physics_process(delta):
	if target != null and is_instance_valid(target):
		self.global_position = target.global_position
