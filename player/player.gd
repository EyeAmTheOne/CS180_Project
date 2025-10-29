extends CharacterBody2D

@export var speed = 100
@onready var animated_sprite = $AnimatedSprite2D

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
	get_input()
	get_orientation()
	move_and_slide()
