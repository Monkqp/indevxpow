extends CharacterBody2D

@export var lifetime: float=1
@export var knockback: float=40
var creatorEntity
var damage
var explosion
var explosion_instance
var world
var positioner
var joe_biden

func _ready():
	$Timer.wait_time=lifetime
	$Timer.start()
	explosion = preload("res://components/small_explosion.tscn")
	world= get_tree().get_root()

func _physics_process(delta):
	#print(self.rotation)
	var collision = move_and_collide(velocity*delta)
	positioner=self.global_position
	if collision:
		var explosion_instance = explosion.instantiate()
		world.add_child(explosion_instance)
		explosion_instance.global_position=positioner
		explosion_instance.emitting=true
		self.queue_free()

func _on_timer_timeout():
	self.queue_free()

		
# Se fija el tipo de area que 
func _on_area_2d_area_entered(states):
	if states==creatorEntity.interaction_area_entity:
		return
	if states.isHitbox and states!=creatorEntity.hitbox_area_entity:
		explosion_instance = explosion.instantiate()
		if positioner !=null:
			world.add_child(explosion_instance)
			explosion_instance.global_position=positioner
			explosion_instance.emitting=true
			states.hitboxParent.health=states.hitboxParent.health-damage
		if positioner!=null:
			joe_biden = Vector2(states.hitboxParent.global_position-creatorEntity.global_position).normalized()
		if joe_biden!=null:
			states.hitboxParent.knockback=(joe_biden*knockback)
			states.hitboxParent.is_knocked_back=true
			states.hitboxParent.knockbacktimer.start()
			#print(states.hitboxParent.velocity)
			#states.hitboxParent.move_and_slide()
			
			#print(joe_biden) # Shit don't work, supposed to be knockback
			#states.hitboxParent.velocity=states.hitboxParent.velocity-(joe_biden*knockback)
	if states==creatorEntity.hitbox_area_entity:
		return
	self.queue_free()
