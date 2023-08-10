extends CPUParticles2D

func _ready():
	$AudioStreamPlayer2D.pitch_scale=randf_range(0.7,1.2)
	#pass

func _on_timer_timeout():
	self.queue_free()

