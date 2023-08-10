extends Node2D

# Load the custom images for the mouse cursor.
var arrow = load("res://assets/sprites/crosshair.png")

func _physics_process(_delta):
	self.global_position=get_global_mouse_position()
