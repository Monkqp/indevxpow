extends CharacterBody2D

var bulletPath
var world
@export var bulletSpeed:float=1.5
@export var bulletLifetime:float=1.5
@export var bulletDamage: int = 1
@export var cooldownTime: float = 10
@export var knockback: float = 40
var marker
var bulletVelocity
var creatorEntity
var cooldownTiner


func _ready():
	bulletPath = preload("res://components/bullet.tscn")
	world= get_tree().get_root()
	marker=self.get_parent()
	creatorEntity=self.get_parent().get_parent()
	cooldownTiner=$CooldownTimer
	$CooldownTimer.wait_time=cooldownTime
	

func _physics_process(_delta):
	
	#if creatorEntity.dead==true: #
	#	return
	# Dispara cuando se apreta "Action", boton de mouse izquierdou
	if Input.is_action_pressed("action") and cooldownTiner.is_stopped():
		$AudioStreamPlayer2D.pitch_scale=randf_range(1.1,1.15)
		$AudioStreamPlayer2D.play()
		cooldownTiner.wait_time = cooldownTime
		cooldownTiner.start()
		creatorEntity.camera_entity.shake(0.15,0.7)
		var bullet_instance = bulletPath.instantiate()
		
		# Crea "POsitioner" el cual tiene la posicion actual
		var positioner=self.global_position
		#$Node2D.add_child(bullet_instance)
		#$Node2D.remove_child(bullet_instance)
		world.add_child(bullet_instance)
		bullet_instance.position=positioner+((get_global_mouse_position()-positioner).normalized()*4)
		
		# Encuentra la direccion en al que tiene que ir la bala
		var bulletDirection=(get_global_mouse_position() - marker.global_position).normalized()
		# Encuentra la velocidad de la bala multiplicando speed con direction
		bulletVelocity=bulletDirection*bulletSpeed*bulletSpeed
		
		# Asigna la velocidad a la bala
		bullet_instance.velocity=bulletVelocity
		bullet_instance.damage=bulletDamage
		bullet_instance.lifetime = bulletLifetime
		bullet_instance.creatorEntity=creatorEntity
		bullet_instance.knockback=knockback
		
