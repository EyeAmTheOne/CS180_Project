extends Node2D

@export var speed: float = 150.0

func _ready() -> void:
	print("TRAIN READY at y=", position.y)

func _process(delta: float) -> void:
	# ALWAYS move down so it's super obvious
	position.y += speed * delta
	print("y =", position.y)
