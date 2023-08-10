extends Sprite2D

func _ready():
	self.look_at(get_local_mouse_position())
	print("why the fuck does this not work holy shit")
	
func _physics_process(delta):
	self.look_at(get_global_mouse_position())
