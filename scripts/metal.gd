extends Node2D
## code for metal same code as tree and coal just diff name 
var rng := RandomNumberGenerator.new()
@export var respawn_time := 10 # metal takes longer 

func _ready():
	rng.randomize()

func harvest(player):
	var amount = get_random_metal_amount()
	player.add_metal(amount)
	hide()
	disable_collisions()
	var t = Timer.new()
	t.wait_time = respawn_time
	t.one_shot = true
	t.connect("timeout", Callable(self, "_respawn_metal"))
	add_child(t)
	t.start()

func _respawn_metal():
	show()
	enable_collisions()

func disable_collisions():
	$StaticBody2D.disable_mode = StaticBody2D.DISABLE_MODE_REMOVE
	$Area2D.monitoring = false
	$Area2D.monitorable = false

func enable_collisions():
	$StaticBody2D.disable_mode = StaticBody2D.DISABLE_MODE_KEEP_ACTIVE
	$Area2D.monitoring = true
	$Area2D.monitorable = true

func get_random_metal_amount() -> int:
	var roll = rng.randi_range(1, 100)
	if roll <= 50:
		return 5
	elif roll <= 75:
		return 8
	elif roll <= 90:
		return 10
	elif roll <= 97:
		return 12
	else:
		return 15
