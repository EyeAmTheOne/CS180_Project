extends Node

var items = {}

func _ready():
	items["wood"] = {
		"name": "Wood",
		"icon": "res://assets/art/small_tree.png"
	}
	items["coal"] = {
		"name": "Coal",
		"icon": "res://assets/art/coal.webp"
	}
	items["metal"] = {
		"name": "Metal",
		"icon": "res://assets/art/pngtree-rock-material-vector-png-image_13459100.png"
	}
	items["gold"] = {
		"name": "Gold",
		"icon": "res://assets/art/gold.jpg"  
	}
	
	items["health_potion"] = {
	"name": "Health Potion",
	"icon": "res://assets/art/chest.jpg"  # placeholder
}

func item_exists(item_name: String) -> bool:
	return items.has(item_name)

func get_item_data(item_name: String) -> Dictionary:
	return items.get(item_name, {})
