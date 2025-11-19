extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var character = $"."
@onready var hitbox = $HitBox/CollisionShape2D

const SPEED = 50

var target = null

func set_target(player: Node2D):
	target = player
	
func get_orientation():
	if velocity[0] > 0:
		# Look left
		animated_sprite.flip_h = false
		#Flip weapon hitbox to be on left side
		hitbox.position[0] = abs(hitbox.position[0])

	elif velocity[0] < 0:
		# Look right
		animated_sprite.flip_h = true
		# Flip weapon hitbox to be on right side
		hitbox.position[0] = -abs(hitbox.position[0])


func _physics_process(delta: float) -> void:
	# If target exists, move towards target
	var direction = Vector2(0, 0)
	if target:
		if position.distance_to(target.position) > 20:
			animated_sprite.play("Walk")
			direction = position.direction_to(target.position)
		else:
			animation_player.play("Attack")
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
