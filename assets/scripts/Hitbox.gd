extends Area2D

var hitboxParent
@export var isHitbox: bool = true

func _ready():
	hitboxParent=get_parent()
