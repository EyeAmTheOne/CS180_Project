class_name Health
extends Node


signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted


@export var max_health: int = 100 : set = set_max_health, get = get_max_health
@export var invulnerability: bool = false : set = set_invulnerability, get = get_invulnerability

var invulnerability_timer: Timer = null

@onready var health: int = max_health : set = set_health, get = get_health


func set_max_health(value: int):
	var clamped_value = 1 if value <= 0 else value
	
	if not clamped_value == max_health:
		var difference = clamped_value - max_health
		max_health = value
		max_health_changed.emit(difference)
		
		if health > max_health:
			health = max_health
	
func get_max_health() -> int:
	return max_health
	
	
func set_invulnerability(value: bool):
	invulnerability = value
	
func get_invulnerability() -> bool:
	return invulnerability
	
func set_temporary_invulnerability(time: float):
	if invulnerability_timer == null:
		invulnerability_timer = Timer.new()
		invulnerability_timer.one_shot = true
		add_child(invulnerability_timer)
		
	if invulnerability_timer.timeout.is_connected(set_invulnerability):
		invulnerability_timer.timeout.disconnect(set_invulnerability)

	invulnerability_timer.set_wait_time(time)
	invulnerability_timer.timeout.connect(set_invulnerability.bind(false))
	invulnerability = true
	invulnerability_timer.start()
	
func set_health(value: int):
	if value < health and invulnerability:
		return
		
	var clamped_value = clampi(value, 0, max_health)
	
	if clamped_value != health:
		var difference = clamped_value - health
		health = value
		health_changed.emit(difference)
		
		if health == 0:
			health_depleted.emit()
	
func get_health() -> int:
	return health
