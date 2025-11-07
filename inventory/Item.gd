extends Node

# Represents a single item in the inventory
var item_name = ""
var quantity = 0

func _init(name = "", amount = 0):
	item_name = name
	quantity = amount

func add(amount):
	quantity += amount

func remove(amount):
	if quantity >= amount:
		quantity -= amount
		return true
	return false

func get_quantity():
	return quantity

func get_item_name():
	return item_name
