extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var character = $"."
@onready var hitbox = $HitBox/CollisionShape2D

enum EnemyState {
	Attacking,
	Chasing,
	Idle,
	Dead,
	Hurt
}

var current_state: EnemyState = EnemyState.Idle

const SPEED = 50

var stun : bool = false
var target = null

func set_target(player: Node2D):
	target = player
	
func get_orientation(direction: Vector2):
	if direction[0] > 0:
		# Look left
		animated_sprite.flip_h = false
		#Flip weapon hitbox to be on left side
		hitbox.position[0] = abs(hitbox.position[0])

	elif direction[0] < 0:
		# Look right
		animated_sprite.flip_h = true
		# Flip weapon hitbox to be on right side
		hitbox.position[0] = -abs(hitbox.position[0])


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var direction = Vector2(0, 0)
	velocity = Vector2(0, 0)
	match current_state:
		EnemyState.Dead:
			return
		EnemyState.Idle:
			if target:
				change_state(EnemyState.Chasing)
		EnemyState.Chasing:
			# If target exists, move towards target
			if !target:
				change_state(EnemyState.Idle)
			else:
				if position.distance_to(target.position) > 20:
					direction = position.direction_to(target.position)
					velocity = direction * SPEED
				else:
					direction = position.direction_to(target.position)
					change_state(EnemyState.Attacking)
				
	
	get_orientation(direction)
	move_and_slide()


func _on_detection_body_entered(body: Node2D) -> void:
	set_target(body)
	

func _on_detection_body_exited(body: Node2D) -> void:
	if body == target:
		target = null


func _on_enemy_health_health_depleted() -> void:
	change_state(EnemyState.Dead)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match current_state:
		EnemyState.Hurt:
			if anim_name == "Hurt":
				change_state(EnemyState.Chasing)
		EnemyState.Attacking:
			if anim_name == "Attack":
				change_state(EnemyState.Chasing)
	


func _on_keep_body_timeout() -> void:
	queue_free()


func _on_hurt_box_received_damage(damage: int) -> void:
	match current_state:
		EnemyState.Dead:
			return
		_:
			change_state(EnemyState.Hurt)
		

func exit_state(old_state: EnemyState):
	match current_state:
		EnemyState.Attacking:
			animation_player.play("RESET")
		_:
			pass

		
func change_state(new_state: EnemyState):
	exit_state(current_state)
	current_state = new_state
	match current_state:
		EnemyState.Dead:
			animated_sprite.play("Death")
			#hitbox.queue_free()
			$KeepBody.start()
		EnemyState.Hurt:
			animation_player.play("Hurt")
		EnemyState.Attacking:
			animation_player.play("Attack")
		EnemyState.Chasing:
			animated_sprite.play("Walk")
		EnemyState.Idle:
			animated_sprite.play("Idle")
			
