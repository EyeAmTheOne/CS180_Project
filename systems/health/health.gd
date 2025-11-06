class_name Health
extends Node


signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted


@export var max_health: int = 100 : set = set_max_health, get = get_max_health
@export var invulnerability: bool = false : set = set_invulnerability, get = get_invulnerability

var invulnerability_timer: Timer = null
var inv_time: float = 2

@onready var health: int = max_health : set = set_health, get = get_health

#Set and get max health
#May be used for upgrade section
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
	
#Set and get invulnerability used to prevent near instant repeated hits
func set_invulnerability(value: bool):
	invulnerability = value
	
func get_invulnerability() -> bool:
	return invulnerability
	
#Invulnerability timer function to start a timer that prevents player from taking damge for its duration
func set_temporary_invulnerability(time: float):
	if invulnerability_timer == null:
		invulnerability_timer = Timer.new()
		add_child(invulnerability_timer)
		
	if invulnerability_timer.timeout.is_connected(set_invulnerability):
		invulnerability_timer.timeout.disconnect(set_invulnerability)

	invulnerability_timer.set_wait_time(time)
	invulnerability_timer.timeout.connect(set_invulnerability.bind(false))
	invulnerability = true
	invulnerability_timer.start()

#Set and get health used in take_damage() and heal()
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
			
		if health > max_health:
			health = max_health
	
func get_health() -> int:
	return health

func take_damage(amount: int):
	#Reduce player health by give amount
	set_health(get_health() - amount)
	
	#Make player invulnerable for 2 seconds
	if !invulnerability:
		set_temporary_invulnerability(inv_time)
		
func heal(amount: int):
	#Increase player health by given amount
	set_health(get_health() + amount)
