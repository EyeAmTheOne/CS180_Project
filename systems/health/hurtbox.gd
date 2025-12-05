class_name HurtBox
extends Area2D


signal received_damage(damage: int)
signal received_healing(healing: int)


@onready var healthbar : ProgressBar = $HealthBar


@export var health: Health


func _ready():
	connect("area_entered", _on_area_entered_HIT)
	connect("area_entered", _on_area_entered_HEAL)
	
	# $Timer.start() # Debug timer to print health every 5 seconds
	

func _on_timer_timeout() -> void:
	print("Current Health: ", health.health)


func _on_area_entered_HIT(hitbox: HitBox) -> void:
	if hitbox != null:
		health.take_damage(hitbox.damage)
		received_damage.emit(hitbox.damage)
		#healthbar.value = health.health
		
func _on_area_entered_HEAL(healbox: HealBox) -> void:
	if healbox != null:
		health.heal(healbox.healing)
		received_healing.emit(healbox.healing)
		#healthbar.value = health.health
		
