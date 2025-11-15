extends Node
# Manages the player's inventory

# Load the scripts we need
const ItemDatabaseScript = preload("res://inventory/ItemDatabase.gd")
const Item = preload("res://inventory/Item.gd")

var items = {}
var max_slots = 20
var item_database 

func _ready():
	item_database = ItemDatabaseScript.new()
	add_child(item_database)

func add_item(item_name, amount = 1):
	# Check if item exists in database
	if not item_database.item_exists(item_name):
		print("Error: Item doesn't exist")
		return false
	
	# If we already have this item, add to it
	if items.has(item_name):
		items[item_name].add(amount)
		print("Added ", amount, " ", item_name)
		return true
	
	# Check if we have room for a new item type
	if items.size() >= max_slots:
		print("Inventory full!")
		return false
	
	# Create new item
	var new_item = Item.new(item_name, amount)
	items[item_name] = new_item
	print("Added ", amount, " ", item_name)
	return true


func remove_item(item_name, amount = 1):
	if not items.has(item_name):
		print("Don't have that item")
		return false
	
	var item = items[item_name]
	if item.get_quantity() < amount:
		print("Not enough ", item_name)
		return false
	
	item.remove(amount)
	
	# Remove item from inventory if quantity is 0
	if item.get_quantity() == 0:
		items.erase(item_name)
	
	print("Removed ", amount, " ", item_name)
	return true


func has_item(item_name, amount = 1):
	if not items.has(item_name):
		return false
	return items[item_name].get_quantity() >= amount


func get_item_quantity(item_name):
	if items.has(item_name):
		return items[item_name].get_quantity()
	return 0


func use_item(item_name):
	# TODO: Add functionality for using consumables
	# For now just remove one item
	if has_item(item_name):
		remove_item(item_name, 1)
		print("Used ", item_name)
		return true
	return false


func get_all_items():
	return items.values()


func print_inventory():
	print("=== Inventory ===")
	if items.is_empty():
		print("Empty")
	else:
		for inventory_item in items.values():
			print(inventory_item.get_name(), ": ", inventory_item.get_quantity())
	print("================")
