extends Area2D

enum OBJECT_STATE {ON, OFF}
var current_state = OBJECT_STATE.ON
var players_in_reach : Array
@export var object_enabled : bool
@export var is_toggleable : bool = true

# Cycles through states
func change_state():
	if current_state == OBJECT_STATE.OFF:
		current_state = OBJECT_STATE.ON
		$PointLight2D.enabled=true
		$AnimationPlayer.play("on")
	elif current_state == OBJECT_STATE.ON:
		current_state = OBJECT_STATE.OFF
		$PointLight2D.enabled=false
		$AnimationPlayer.play("off")

# Makes sure the object is at the state it is spawned in
func _ready():
	if object_enabled == true:
		$PointLight2D.enabled=true
		$AnimationPlayer.play("on")
	else:
		change_state()

func _physics_process(_delta):
	if Input.is_action_just_pressed("interact") and players_in_reach.has("PlayerInteractArea") and is_toggleable==true:
		change_state()



# Gets an array with all the names of the areas which are currently in the object's area
func _on_area_entered(area):
	players_in_reach=players_in_reach + [area.get_name()]
func _on_area_exited(area):
	players_in_reach.erase(area.get_name())

