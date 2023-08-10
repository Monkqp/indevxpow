extends Area2D

enum TORCH_STATE {ON, OFF}
var current_state = TORCH_STATE.ON
var players_in_reach : Array
@export var torch_enabled : bool
@export var torch_is_toggleable : bool = true

# Cycles through states
func change_state():
	if current_state == TORCH_STATE.OFF:
		current_state = TORCH_STATE.ON
		$PointLight2D.enabled=true
		$AnimationPlayer.play("on")
		$Torch_sprite/Fire.play("fire_on")
	elif current_state == TORCH_STATE.ON:
		current_state = TORCH_STATE.OFF
		$PointLight2D.enabled=false
		$AnimationPlayer.play("off")
		$Torch_sprite/Fire.play("fire_off")

# Makes sure the torch is at the state it is spawned in
func _ready():
	if torch_enabled == true:
		$PointLight2D.enabled=true
		$AnimationPlayer.play("on")
	else:
		change_state()

func _physics_process(_delta):
	if Input.is_action_just_pressed("interact") and players_in_reach.has("PlayerInteractArea") and torch_is_toggleable==true:
		change_state()




func _on_area_entered(area):
	players_in_reach=players_in_reach + [area.get_name()]
	
func _on_area_exited(area):
	players_in_reach.erase(area.get_name())
