extends CharacterBody2D
@export var enemy_active : bool = true
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

var current_attack : bool = false
var stun : bool = false
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


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var direction = Vector2(0, 0)
	match current_state:
		EnemyState.Dead:
			return
		EnemyState.Hurt:
			velocity = direction * SPEED
			get_orientation()
			move_and_slide()
		_:
			if enemy_active:
				# If target exists, move towards target
				if target:
					if position.distance_to(target.position) > 20:
						cancel_attack()
						animated_sprite.play("Walk")
						direction = position.direction_to(target.position)
					elif !current_attack:
						current_attack = true
						animation_player.play("Attack")
				else:
					cancel_attack()
					animated_sprite.play("Idle")
					
				velocity = direction * SPEED
				get_orientation()
				move_and_slide()
				
			else:
				cancel_attack()
				change_state(EnemyState.Dead)


func _on_detection_body_entered(body: Node2D) -> void:
	set_target(body)
	

func _on_detection_body_exited(body: Node2D) -> void:
	if body == target:
		target = null


func _on_enemy_health_health_depleted() -> void:
	enemy_active = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match current_state:
		EnemyState.Hurt:
			if anim_name == "Hurt":
				change_state(EnemyState.Chasing)
				current_attack = false
		_:
			if anim_name == "Attack":
				current_attack = false
	


func _on_keep_body_timeout() -> void:
	queue_free()


func _on_hurt_box_received_damage(damage: int) -> void:
	if enemy_active:
		cancel_attack()
		change_state(EnemyState.Hurt)


func cancel_attack():
	if current_attack:
		current_attack = false
		hitbox.disabled = true
		animation_player.stop()
		
		
func change_state(new_state: EnemyState):
	current_state = new_state
	match current_state:
		EnemyState.Dead:
			animated_sprite.play("Death")
			$KeepBody.start()
		EnemyState.Hurt:
			animation_player.play("Hurt")
			
