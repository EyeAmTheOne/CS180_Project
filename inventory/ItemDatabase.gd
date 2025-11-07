extends Node

# Stores all the item definitions for the game
var items = {}

func _ready():
	items["wood"] = {
		"name": "Wood",
		"description": "Basic resource for crafting",
		"max_stack": 99
	}
	
	items["metal"] = {
		"name": "Metal scrap",
		"description": "Used for upgrades",
		"max_stack": 99
	}
	
	items["coal"] = {
		"name": "Coal",
		"description": "Fuel for the train",
		"max_stack": 50
	}
	
	items["health_potion"] = {
		"name": "Health Potion",
		"description": "Restores health",
		"max_stack": 5
	}

func item_exists(item_name):
	return items.has(item_name)

func get_item(item_name):
	if items.has(item_name):
		return items[item_name]
	return null
