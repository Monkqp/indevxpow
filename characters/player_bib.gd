extends CharacterBody2D

@export var move_speed : float = 100
@export var sprint_speed : float = 150
@export var animation_speed : float = 60
@export var interaction_area : float = 1.5
@export var health : int = 5
@export var friction: float = 0.05

var dead: bool = false
var screen_shook: bool = false
var n: int = 0
var interaction_area_entity
var hitbox_area_entity
var camera_entity
var temp_health_checker
var knockback:Vector2=Vector2(0,0)
var knockbacktimer
var is_knocked_back:bool=false
var input_direction
var motion=Vector2.ZERO

func _ready():
	update_death_state()
	update_interaction_area()
	hitbox_area_entity=$Hitbox
	interaction_area_entity=$PlayerInteractArea # Interaction area is set when the player spawns
	camera_entity=$Camera2D
	knockbacktimer=$KnockbackTimer
	
# Depending on the direction the player is moving, flips them horizontally
func animate_walk_when_moving(): 
	if velocity.x !=0 or velocity.y!=0: # Makes the player use the walk animation when they are moving
		$AnimationPlayer.play("walk")
		if velocity.x>0:
			$Sprite2D.flip_h=false
		elif velocity.x<0:
			$Sprite2D.flip_h=true
	else: # Whenever the player is still, they will play the idle animation
		$AnimationPlayer.play("idle")
		

# For aiming. Wherever the mouse is the player will flip to match
func flip_player_on_mouse_pos():
	if get_global_mouse_position().x > position.x: # 
		$Sprite2D.flip_h=false

	elif get_global_mouse_position().x < position.x:
		$Sprite2D.flip_h=true

# Determines the player velocity and animation speed
func walk_and_run(): 
	if Input.is_action_pressed("sprint"): # When they sprint, they'll move at the sprint speed
		velocity = input_direction*sprint_speed+knockback
		$AnimationPlayer.speed_scale=sprint_speed/animation_speed # Makes the animation match the speed
	else: # When they are not sprinting, they'll move at the normal move speed
		velocity = input_direction * move_speed+knockback
		$AnimationPlayer.speed_scale=move_speed/animation_speed

# Scales the interaction area of the player using an exported variable
func update_interaction_area(): 
	$PlayerInteractArea/CollisionShape2D.scale=Vector2(interaction_area,interaction_area)

func update_death_state():
	if health <= 0:
		dead=true
		$AnimationPlayer.play("dead")
		if screen_shook==true:
			return
		$Camera2D.shake(0.15,3)
		screen_shook=true
		$PlayerOrbitHolder.queue_free()
	else:
		dead=false

func shake_on_damage_taken():
	if temp_health_checker>health:
		$Camera2D.shake(0.1,2)
		
func get_input_axis():
		input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _physics_process(delta):
	#if Input.is_action_just_pressed("interact"):
	#	health = health-1
	update_death_state()
	temp_health_checker = health
	
	if dead == true:
		return
	
	get_input_axis()
	
	if Input.is_action_just_pressed("ui_accept"):
		health=health-1
	walk_and_run()
	
	velocity = lerp(velocity, Vector2.ZERO, friction)
	
	animate_walk_when_moving()
	#if Input.is_action_pressed("aiming"): 	# Enables aiming whenever the player is aiming (with the right
	#	flip_player_on_mouse_pos()			# mouse button for now)
	flip_player_on_mouse_pos()
	move_and_slide()
	shake_on_damage_taken()
	


func _on_knockback_timer_timeout():
	knockback=Vector2(0,0)
	is_knocked_back=false
