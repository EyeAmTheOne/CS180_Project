extends Node2D

@export var engine: Node2D
@export var follow_distance: float = 64.0
@export var follow_speed: float = 10.0  

func _process(delta: float) -> void:
	if engine == null:
		return

	
	var target_pos := engine.position + Vector2(0, follow_distance)

	
	target_pos.x = engine.position.x
	position.x = engine.position.x

	
	position.y = lerp(position.y, target_pos.y, follow_speed * delta)
