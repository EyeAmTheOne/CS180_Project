extends CharacterBody2D

@export var speed = 100
@export var player_active : bool = true
@onready var animated_sprite = $AnimatedSprite2D

var player_dead : bool = false

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	

func get_orientation():
	if velocity[0] > 0:
		# Look left
		animated_sprite.flip_h = false
	elif velocity[0] < 0:
		# Look right
		animated_sprite.flip_h = true

func _physics_process(delta):	
	if player_active:
		get_input()
		get_orientation()
		move_and_slide()
	
	if player_active:
		if !Input.get_vector("left", "right", "up", "down").is_zero_approx():
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
	else:
		if !player_dead:
			animated_sprite.play("death")
			player_dead = true


func _on_player_health_health_depleted() -> void:
	player_active = false
	print("YOU HAVE DIED")
