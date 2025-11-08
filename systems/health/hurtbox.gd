class_name HurtBox
extends Area2D


signal received_damage(damage: int)
signal received_healing(healing: int)


@export var health: Health


func _ready():
	connect("area_entered", _on_area_entered_HIT)
	connect("area_entered", _on_area_entered_HEAL)
	$Timer.start()
	

func _on_timer_timeout() -> void:
	print("Current Health: ", health.health)


func _on_area_entered_HIT(hitbox: HitBox) -> void:
	if hitbox != null:
		health.take_damage(hitbox.damage)
		print("DAMAGED: ", hitbox.damage)
		
func _on_area_entered_HEAL(healbox: HealBox) -> void:
	if healbox != null:
		health.heal(healbox.healing)
		print("HEALING: ", healbox.healing)
