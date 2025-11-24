class_name HitBox
extends Area2D

@export var damage: int = 25 : set = set_damage, get = get_damage

func _ready():
	# Make hitbox inactive by default
	$CollisionShape2D.disabled = true

func set_damage(value: int):
	damage = value
	
func get_damage() -> int:
	return damage
