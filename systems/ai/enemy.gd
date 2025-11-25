extends CharacterBody2D
@export var enemy_active : bool = true
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var character = $"."
@onready var hitbox = $HitBox/CollisionShape2D

const SPEED = 50

var enemy_dead : bool = false
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
	if enemy_active:
		# If target exists, move towards target
		var direction = Vector2(0, 0)
		if !stun:
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
		if !enemy_dead:
			cancel_attack()
			animated_sprite.play("Death")
			$KeepBody.start()
			enemy_dead = true


func _on_detection_body_entered(body: Node2D) -> void:
	set_target(body)
	

func _on_detection_body_exited(body: Node2D) -> void:
	if body == target:
		target = null


func _on_enemy_health_health_depleted() -> void:
	enemy_active = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack":
		current_attack = false
	elif anim_name == "Hurt":
		stun = false
		current_attack = false


func _on_keep_body_timeout() -> void:
	queue_free()


func _on_hurt_box_received_damage(damage: int) -> void:
	if enemy_active:
		cancel_attack()
		stun = true
		animation_player.play("Hurt")

func cancel_attack():
	if current_attack:
		current_attack = false
		hitbox.disabled = true
		animation_player.stop()
