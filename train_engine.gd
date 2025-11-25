extends Node2D

@export var speed: float = 150.0
@export var top_y: float = -250.0
@export var bottom_y: float = 250.0

@export var require_fuel: bool = true
@export var fuel_needed_to_start: int = 10
@export var interaction_radius: float = 80.0  # how close player must be

var fuel: int = 0
var has_fuel: bool = false
var direction: float = 0.0


func _ready() -> void:
	print("TrainEngine READY, fuel =", fuel)


func _get_player() -> Node:
	# assume your main scene root has a child called "Player"
	var root := get_tree().current_scene
	if root and root.has_node("Player"):
		return root.get_node("Player")
	return null


func _try_add_fuel_from_player(player: Node) -> void:
	# assumes player.gd has: var wood, var coal
	var wood_to_use: int = min(player.wood, 10)
	var coal_to_use: int = min(player.coal, 5)

	if wood_to_use == 0 and coal_to_use == 0:
		print("Not enough wood/coal for the train")
		return

	player.wood -= wood_to_use
	player.coal -= coal_to_use

	fuel += wood_to_use + coal_to_use
	print("Added fuel:", wood_to_use, "wood,", coal_to_use, "coal. Total fuel =", fuel)

	if fuel >= fuel_needed_to_start and not has_fuel:
		has_fuel = true
		print(" Train is now powered! You can move it.")


func _process(delta: float) -> void:
	# -------- INTERACT / FUEL --------
	if Input.is_action_just_pressed("interact"):
		var player := _get_player()
		if player:
			var dist := global_position.distance_to(player.global_position)
			print("E PRESSED, distance to player =", dist)
			if dist <= interaction_radius:
				_try_add_fuel_from_player(player)
			else:
				print("Player too far from train to add fuel")
		else:
			print("E PRESSED but Player node not found")

	# -------- FUEL GATE --------
	if require_fuel and not has_fuel:
		return

	# -------- MOVEMENT --------
	if Input.is_action_pressed("train_up"):
		direction = -1.0
	elif Input.is_action_pressed("train_down"):
		direction = 1.0
	elif Input.is_action_just_pressed("train_stop"):
		direction = 0.0

	if direction != 0.0:
		position.y += speed * direction * delta
		position.y = clamp(position.y, top_y, bottom_y)
