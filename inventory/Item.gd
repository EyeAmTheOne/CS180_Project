extends Node

# Represents a single item in the inventory
var item_name = ""
var quantity = 0
var item_data = {}

func _init(name = "", amount = 0):
	item_name = name
	quantity = amount
	# Get the item data from ItemDatabase
	item_data = ItemDatabase.get_item_data(name)

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

func get_icon() -> String:
	return item_data.get("icon", "")
