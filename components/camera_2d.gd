extends Camera2D

var shake_amount = 0
var default_offset = offset
var tween
var timer
var player
var limit_y
var limit_x
var mid_x
var mid_y
var target


var point_x
var point_y


#I have no idea as to why this works. I wrote it like 5 months ago and I recall absolutely nothing about it

@export var zoom_amount: float = 10
@export var zoom_modifier:float  = 0.8
@export var interpolate_val = 1
@export var radius:float=10

var shook_on_death
func _ready():
	player = self.get_parent()
	set_process(false)
	zoom=Vector2(zoom_amount,zoom_amount)
	timer=$Timer
	randomize()
	
func _process(_delta):
	offset= Vector2(randf_range(-1,1)*shake_amount,
	randf_range(-1,1)*shake_amount)
	
func shake(time,amount):
	if time ==0:
		return
	timer.wait_time=time
	shake_amount=amount
	set_process(true)
	timer.start()

func _physics_process(delta):
	
	# Takes a target and finds the mid way point to it
	target = player.global_position 
	point_x = (target.x + (get_global_mouse_position().x)) / 2
	point_y = (target.y + (get_global_mouse_position().y)) / 2
	
	
	# Holy shit. I might have found the -worst- way to find a n-way (half-way, quarter-way) point between any
	# two points
	if Input.is_action_pressed("aiming")!=true:
		for n in radius:
			point_x = ((target.x + point_x) / 2)
			point_y = ((target.y + point_y) / 2)
	

	
	global_position = global_position.lerp(Vector2(point_x,point_y), interpolate_val * delta)
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom=zoom+zoom*zoom_modifier
		
	if Input.is_action_just_pressed("zoom_out"):
		zoom=zoom-zoom*zoom_modifier

func _on_timer_timeout():
	set_process(false)
	
