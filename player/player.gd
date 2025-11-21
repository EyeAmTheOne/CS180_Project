extends CharacterBody2D

@export var speed = 100
@export var player_active : bool = true
@onready var animated_sprite = $AnimatedSprite2D
@onready var animated_player = $AnimationPlayer
@onready var hitbox = $HitBox/CollisionShape2D

var player_dead : bool = false
var current_attack : bool = false

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	

func get_orientation():
	if velocity[0] > 0:
		# Look left
		animated_sprite.flip_h = false
		#Flip weapon hitbox to the left
		#hitbox.position[0] = abs(hitbox.position[0])
	elif velocity[0] < 0:
		# Look right
		animated_sprite.flip_h = true
		#Flip weapon hitbox to the right
		#hitbox.position[0] = -abs(hitbox.position[0])
		

func _physics_process(delta):	
	if player_active:
		get_input()
		get_orientation()

		if !current_attack:
			if Input.is_action_just_pressed("attack"):
				current_attack = true
				attack_animation()
				

		move_and_slide()

		if !current_attack:
			if !Input.get_vector("left", "right", "up", "down").is_zero_approx():
				animated_sprite.play("walk")
			else:
				animated_sprite.play("idle")
	else:
		if !player_dead:
			animated_sprite.play("death")
			player_dead = true

func attack_animation():
	if current_attack:
		animated_sprite.play("attack")

func _on_animated_sprite_2d_animation_finished() -> void:
	current_attack = false

func _on_player_health_health_depleted() -> void:
	player_active = false
	print("YOU HAVE DIED")
