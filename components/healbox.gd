class_name HealBox
extends Area2D

@export var healing: int = 25 : set = set_healing, get = get_healing


func set_healing(value: int):
	healing = value
	
func get_healing() -> int:
	return healing
