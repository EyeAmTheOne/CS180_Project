extends GutTest

# GUT Unit tests for the inventory system
# Week 7 - Testing

const Inventory = preload("res://inventory/Inventory.gd")

var inventory

func before_each():
	# Create fresh inventory for each test
	inventory = autofree(Inventory.new())
	add_child(inventory)

func after_each():
	for item in inventory.get_all_items():
		inventory.remove_item(item, inventory.get_item_quantity(item))
	inventory.free()
	# GUT handles cleanup automatically with add_child_autofree

# Test 1: Adding a single item
func test_add_single_item():
	var result = inventory.add_item("wood", 5)
	
	assert_true(result, "add_item should return true")
	assert_eq(inventory.get_item_quantity("wood"), 5, "Should have 5 wood")

# Test 2: Adding multiple different items
func test_add_multiple_items():
	inventory.add_item("wood", 10)
	inventory.add_item("metal", 5)
	inventory.add_item("coal", 3)
	
	assert_eq(inventory.get_item_quantity("wood"), 10, "Should have 10 wood")
	assert_eq(inventory.get_item_quantity("metal"), 5, "Should have 5 metal")
	assert_eq(inventory.get_item_quantity("coal"), 3, "Should have 3 coal")

# Test 3: Items stack correctly
func test_add_item_stacking():
	inventory.add_item("wood", 5)
	inventory.add_item("wood", 3)
	
	assert_eq(inventory.get_item_quantity("wood"), 8, "Wood should stack to 8 (5 + 3)")

# Test 4: Remove item
func test_remove_item():
	inventory.add_item("wood", 10)
	var result = inventory.remove_item("wood", 3)
	
	assert_true(result, "remove_item should return true")
	assert_eq(inventory.get_item_quantity("wood"), 7, "Should have 7 wood remaining")

# Test 5: Remove nonexistent item
func test_remove_nonexistent_item():
	var result = inventory.remove_item("wood", 1)
	
	assert_false(result, "Should not be able to remove nonexistent item")

# Test 6: Remove more than available
func test_remove_too_many():
	inventory.add_item("wood", 5)
	var result = inventory.remove_item("wood", 10)
	
	assert_false(result, "Should not remove more than available")
	assert_eq(inventory.get_item_quantity("wood"), 5, "Quantity should remain unchanged")

# Test 7: has_item checks
func test_has_item():
	inventory.add_item("wood", 10)
	
	assert_true(inventory.has_item("wood", 5), "Should have at least 5 wood")
	assert_true(inventory.has_item("wood", 10), "Should have at least 10 wood")
	assert_false(inventory.has_item("wood", 15), "Should not have 15 wood")
	assert_false(inventory.has_item("metal", 1), "Should not have any metal")

# Test 8: get_item_quantity
func test_get_item_quantity():
	inventory.add_item("wood", 15)
	
	assert_eq(inventory.get_item_quantity("wood"), 15, "Should return 15 for wood")
	assert_eq(inventory.get_item_quantity("metal"), 0, "Should return 0 for nonexistent item")

# Test 9: Inventory full
func test_inventory_full():
	# Set small limit for testing
	inventory.max_slots = 3
	
	inventory.add_item("wood", 1)
	inventory.add_item("metal", 1)
	inventory.add_item("coal", 1)
	
	# Try to add 4th item type (should fail)
	var result = inventory.add_item("health_potion", 1)
	
	assert_false(result, "Should not exceed max slots")
	assert_eq(inventory.get_item_quantity("health_potion"), 0, "health_potion should not be added")

# Test 10: Use item
func test_use_item():
	inventory.add_item("health_potion", 3)
	var result = inventory.use_item("health_potion")
	
	assert_true(result, "use_item should return true")
	assert_eq(inventory.get_item_quantity("health_potion"), 2, "Should have 2 potions remaining")

# Test 11: Use nonexistent item
func test_use_nonexistent_item():
	var result = inventory.use_item("health_potion")
	
	assert_false(result, "Should not be able to use item that doesn't exist")

# Test 12: Get all items
func test_get_all_items():
	inventory.add_item("wood", 10)
	inventory.add_item("metal", 5)
	
	var items = inventory.get_all_items()
	
	assert_eq(items.size(), 2, "Should have 2 different item types")
