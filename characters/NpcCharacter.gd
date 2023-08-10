extends CharacterBody2D
enum NPC_STATE {IDLE, WALK}
@export var move_speed : float = 100
@export var sprint_speed : float = 150
@export var animation_speed : float = 60
@export var brain_dead : bool = false
@export var health : int = 5
@export var sprite_texture = 0
@export var curve: Curve

var is_knocked_back: bool=false
var temp_health_checker
var dead : bool = false
var knockbacktimer
var knockback:Vector2=Vector2(0,0)
var time = 0
var animationPlayer
var playedHit:bool=false

var damage_sound_played=false

var current_state = NPC_STATE.IDLE
var move_direction = Vector2(0,0)

var sprite0 = preload("res://assets/sprites/pink-npc-sprite.png")
var sprite1 = preload("res://assets/sprites/alt1-bib-sprite.png")
var sprite2 = preload("res://assets/sprites/thing.png")

func pick_texture():
	match(sprite_texture):
		0:
			$Sprite2D.set_texture(sprite0)
		1:
			$Sprite2D.set_texture(sprite1)
		2:
			$Sprite2D.set_texture(sprite2)

func _ready():
	pick_texture()
	knockbacktimer=$KnockbackTimer
	animationPlayer=$AnimationPlayer

func animate_walk_when_moving():
	if velocity.x !=0 or velocity.y !=0 and !is_knocked_back:
		$AnimationPlayer.play("walk")
		if velocity.x>0:
			$Sprite2D.flip_h=false
		elif velocity.x<0:
			$Sprite2D.flip_h=true
	else:
		$AnimationPlayer.play("idle")


func pick_direction():
	if !dead:
		move_direction = Vector2(
			randi_range(-1,1),
			randi_range(-1,1)
		)

func update_death_state():
	if health <= 0:
		dead=true
		$CollisionShape2D.disabled=true
		$Hitbox.isHitbox=false
		$Hitbox.set_collision_layer_value(2,false)
		$Hitbox.set_collision_mask_value(2,false)
		$Hitbox.set_collision_layer_value(3,true)
		$AnimationPlayer.play("dead")
		$Sprite2D.modulate= Color(0,1,0)
	else:
		dead=false

func pick_new_state():
	if !dead:
		if current_state == NPC_STATE.IDLE:
			current_state = NPC_STATE.WALK
			pick_direction()
		elif current_state == NPC_STATE.WALK:
			current_state = NPC_STATE.IDLE
			move_direction=Vector2(0,0)

func on_damage_taken():
	
	if !damage_sound_played:
		
		$AudioStreamPlayer2D.pitch_scale=randf_range(0.75,1.1)
		$AudioStreamPlayer2D.play()
		damage_sound_played=true

func _physics_process(delta):
	temp_health_checker = health
	#print(temp_health_checker)
	if is_knocked_back:
		update_death_state()
		if !playedHit:
			animationPlayer.play("hit")
			playedHit=true
		on_damage_taken()
		time = time+3*delta
		velocity=Vector2(0,0)
		var function_y=curve.sample(time)
		#print(time)
		#print(function_y)
		velocity=move_direction*move_speed+knockback*function_y
		move_and_slide()
		
		
	update_death_state()
	
	if dead:
		return
	if brain_dead:
		current_state = NPC_STATE.IDLE
		move_direction=Vector2(0,0)
	velocity = move_direction*move_speed+knockback
	
	if !is_knocked_back:
		animate_walk_when_moving()
		move_and_slide()
	#print(health)

func _on_state_timer_state_timeout():
	pick_new_state()
	$TimerState.start(randi_range(1,3))

func _on_knockback_timer_timeout():
	playedHit=false
	knockback=Vector2(0,0)
	is_knocked_back=false
	damage_sound_played=false
	time=0
