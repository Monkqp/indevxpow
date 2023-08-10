extends Marker2D

func _physics_process(_delta):
	# Makes whatever is atached to OrbitAim and off-center rotate. OrbitAim itself also rotates, however
	# It does not orbit the player
	self.look_at(get_global_mouse_position())
	if self.global_rotation>=-1.5 and self.global_rotation<=1.5:
		for child in self.get_children():
			child.scale=Vector2(1,1)
	else:
		for child in self.get_children():
			child.scale=Vector2(1,-1)	
	for child in self.get_children():
		child.z_index=-1
	if self.global_rotation >= 0:
		for child in self.get_children():
			child.z_index=0
