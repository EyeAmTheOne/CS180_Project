extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = max_value

# When the entity takes damage
func _on_hurt_box_received_damage(damage: int) -> void:
	value = get_parent().health.health
