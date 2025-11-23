extends Node2D

var rng := RandomNumberGenerator.new()

# tree respwn timer (in seconds)
@export var respawn_time := 5 # 2 minutes

func _ready():
	rng.randomize()

func harvest(player):
	var amount = get_random_wood_amount()
	player.add_wood(amount)

	# Hide tree and does not delete it 
	hide()
	disable_collisions()

	# timer starts 
	var t = Timer.new()
	t.wait_time = respawn_time
	t.one_shot = true
	t.connect("timeout", Callable(self, "_respawn_tree"))
	add_child(t)
	t.start()

func _respawn_tree():
	show()
	enable_collisions()


# SAFE COLLISION TOGGLE

func disable_collisions():
	var shape = $StaticBody2D.get_child(0)  # CollisionShape2D
	shape.disabled = true

	$Area2D.monitoring = false
	$Area2D.monitorable = false

func enable_collisions():
	var shape = $StaticBody2D.get_child(0)  # CollisionShape2D
	shape.disabled = false

	$Area2D.monitoring = true
	$Area2D.monitorable = true


# RANDOM values function 

func get_random_wood_amount():
	var roll = rng.randi_range(1, 100)

	if roll <= 50:
		return rng.randi_range(3, 8)      # common
	elif roll <= 80:
		return rng.randi_range(8, 15)     # uncommon
	elif roll <= 95:
		return rng.randi_range(15, 20)    # rare
	else:
		return rng.randi_range(20, 25)    # super rare
