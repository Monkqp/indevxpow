extends CharacterBody2D
var initial_position
func _ready():
	initial_position=self.global_position

func _physics_process(_delta):
	velocity=Vector2(100,0)
	move_and_slide()


func _on_timer_timeout():
	self.position=initial_position
