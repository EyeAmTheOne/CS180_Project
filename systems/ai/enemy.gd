extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 50

var target = null

func set_target(player: Node2D):
	target = player
	
func get_orientation():
	if velocity[0] > 0:
		# Look left
		animated_sprite.flip_h = false
	elif velocity[0] < 0:
		# Look right
		animated_sprite.flip_h = true

func _physics_process(delta: float) -> void:
	# If target exists, move towards target
	var direction = Vector2(0, 0)
	if target and position.distance_to(target.position) > 10:
		animated_sprite.play("Walk")
		direction = position.direction_to(target.position)
	else:
		animated_sprite.play("Idle")
		
	velocity = direction * SPEED
	get_orientation()
	move_and_slide()


func _on_detection_body_entered(body: Node2D) -> void:
	set_target(body)
	

func _on_detection_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
