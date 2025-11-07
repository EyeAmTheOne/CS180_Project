extends Node
# Basic demo to show inventory working

const Inventory = preload("res://inventory/Inventory.gd")
var inventory

func _ready():
	inventory = Inventory.new()
	add_child(inventory)
	
	print("\n=== INVENTORY DEMO ===\n")
	
	# Add some items
	print("Adding items...")
	inventory.add_item("wood", 10)
	inventory.add_item("metal", 5)
	inventory.add_item("health_potion", 3)
	
	print("\nCurrent inventory:")
	inventory.print_inventory()
	
	# Check items
	print("\nChecking items...")
	print("Has 5 wood? ", inventory.has_item("wood", 5))
	print("Wood quantity: ", inventory.get_item_quantity("wood"))
	
	# Remove items
	print("\nRemoving 3 wood...")
	inventory.remove_item("wood", 3)
	
	print("\nFinal inventory:")
	inventory.print_inventory()
