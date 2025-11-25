extends Node2D

@export var enemy_scene: PackedScene
@onready var spawn_timer = $Timer

func _ready():
	randomize()
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)

func _on_spawn_timer_timeout():
	var enemy = enemy_scene.instantiate()
	# Get a random position within the viewport
	var screen_size = get_viewport_rect().size
	var random_x = randi_range(0, int(screen_size.x))
	var random_y = randi_range(0, int(screen_size.y)) # For 2D
	
	enemy.position = Vector2(random_x, random_y)
	
	# Add the enemy to the "Enemies" node, not the spawner
	$"../Enemies".add_child(enemy)
	print("Enemy spawned at ", enemy.position)
