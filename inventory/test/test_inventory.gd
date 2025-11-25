extends Node

# Unit tests for the inventory system
# Week 7 - Testing

const Inventory = preload("res://inventory/Inventory.gd")

var inventory
var tests_passed = 0
var tests_failed = 0

func _ready():
	print("\n" + "=".repeat(50))
	print("INVENTORY UNIT TESTS - Week 7")
	print("=".repeat(50) + "\n")
	
	# Run all tests
	test_add_single_item()
	test_add_multiple_items()
	test_add_item_stacking()
	test_remove_item()
	test_remove_nonexistent_item()
	test_remove_too_many()
	test_has_item()
	test_get_item_quantity()
	test_inventory_full()
	test_use_item()
	
	# Print results
	print("\n" + "=".repeat(50))
	print("TEST RESULTS")
	print("=".repeat(50))
	print("Passed: ", tests_passed)
	print("Failed: ", tests_failed)
	if tests_failed == 0:
		print("✓ ALL TESTS PASSED")
	else:
		print("✗ SOME TESTS FAILED")
	print("=".repeat(50) + "\n")

func setup():
	# Create fresh inventory for each test
	inventory = Inventory.new()
	add_child(inventory)

func teardown():
	# Clean up after each test
	inventory.queue_free()
	inventory = null

# Test 1: Adding a single item
func test_add_single_item():
	print("TEST: Add single item")
	setup()
	
	var result = inventory.add_item("wood", 5)
	
	if result == true and inventory.get_item_quantity("wood") == 5:
		print("  ✓ PASS: Successfully added 5 wood\n")
		tests_passed += 1
	else:
		print("  ✗ FAIL: Expected 5 wood, got ", inventory.get_item_quantity("wood"), "\n")
		tests_failed += 1
	
	teardown()

# Test 2: Adding multiple different items
func test_add_multiple_items():
	print("TEST: Add multiple different items")
	setup()
	
	inventory.add_item("wood", 10)
	inventory.add_item("metal", 5)
	inventory.add_item("coal", 3)
	
	var wood_qty = inventory.get_item_quantity("wood")
	var metal_qty = inventory.get_item_quantity("metal")
	var coal_qty = inventory.get_item_quantity("coal")
	
	if wood_qty == 10 and metal_qty == 5 and coal_qty == 3:
		print("  ✓ PASS: All items added correctly\n")
		tests_passed += 1
	else:
		print("  ✗ FAIL: Expected wood=10, metal=5, coal=3")
		print("    Got wood=", wood_qty, ", metal=", metal_qty, ", coal=", coal_qty, "\n")
		tests_failed += 1
	
	teardown()

# Test 3: Items stack correctly
func test_add_item_stacking():
	print("TEST: Item stacking")
	setup()
	
	inventory.add_item("wood", 5)
	inventory.add_item("wood", 3)
	
	if inventory.get_item_quantity("wood") == 8:
		print("  ✓ PASS: Items stacked correctly (5 + 3 = 8)\n")
		tests_passed += 1
	else:
		print("  ✗ FAIL: Expected 8 wood, got ", inventory.get_item_quantity("wood"), "\n")
		tests_failed += 1
	
	teardown()

# Test 4: Remove item
func test_remove_item():
	print("TEST: Remove item")
	setup()
	
	inventory.add_item("wood", 10)
	var result = inventory.remove_item("wood", 3)
	
	if result == true and inventory.get_item_quantity("wood") == 7:
		print("  ✓ PASS: Removed 3 wood, 7 remaining\n")
		tests_passed += 1
	else:
		print("  ✗ FAIL: Expected 7 wood, got ", inventory.get_item_quantity("wood"), "\n")
		tests_failed += 1
	
	teardown()

# Test 5: Remove nonexistent item
func test_remove_nonexistent_item():
	print("TEST: Remove nonexistent item")
	setup()
	
	var result = inventory.remove_item("wood", 1)
	
	if result == false:
		print("  ✓ PASS: Correctly failed to remove nonexistent item\n")
		tests_passed += 1
	else:
		print("  ✗ FAIL: Should not be able to remove item that doesn't exist\n")
		tests_failed += 1
	
	teardown()

# Test 6: Remove more than available
func test_remove_too_many():
	print("TEST: Remove more items than available")
	setup()
	
	inventory.add_item("wood", 5)
	var result = inventory.remove_item("wood", 10)
	
	if result == false and inventory.get_item_quantity("wood") == 5:
		print("  ✓ PASS: Correctly prevented over-removal\n")
		tests_passed += 1
	else:
		print("  ✗ FAIL: Should not remove more than available\n")
		tests_failed += 1
	
	teardown()

# Test 7: has_item checks
func test_has_item():
	print("TEST: has_item function")
	setup()
	
	inventory.add_item("wood", 10)
	
	var has_5 = inventory.has_item("wood", 5)
	var has_10 = inventory.has_item("wood", 10)
	var has_15 = inventory.has_item("wood", 15)
	var has_metal = inventory.has_item("metal", 1)
	
	if has_5 and has_10 and not has_15 and not has_metal:
		print("  ✓ PASS: has_item checks work correctly\n")
		tests_passed += 1
	else:
		print("  ✗ FAIL: has_item not working correctly\n")
		tests_failed += 1
	
	teardown()

# Test 8: get_item_quantity
func test_get_item_quantity():
	print("TEST: get_item_quantity")
	setup()
	
	inventory.add_item("wood", 15)
	
	var qty = inventory.get_item_quantity("wood")
	var qty_none = inventory.get_item_quantity("metal")
	
	if qty == 15 and qty_none == 0:
		print("  ✓ PASS: Quantities returned correctly\n")
		tests_passed += 1
	else:
		print("  ✗ FAIL: Expected wood=15, metal=0. Got wood=", qty, ", metal=", qty_none, "\n")
		tests_failed += 1
	
	teardown()

# Test 9: Inventory full
func test_inventory_full():
	print("TEST: Inventory slot limit")
	setup()
	
	# Set small limit for testing
	inventory.max_slots = 3
	
	inventory.add_item("wood", 1)
	inventory.add_item("metal", 1)
	inventory.add_item("coal", 1)
	
	# Try to add 4th item type (should fail)
	var result = inventory.add_item("health_potion", 1)
	
	if result == false and inventory.get_item_quantity("health_potion") == 0:
		print("  ✓ PASS: Correctly enforced inventory limit\n")
		tests_passed += 1
	else:
		print("  ✗ FAIL: Should not exceed max slots\n")
		tests_failed += 1
	
	teardown()

# Test 10: Use item
func test_use_item():
	print("TEST: Use item")
	setup()
	
	inventory.add_item("health_potion", 3)
	var result = inventory.use_item("health_potion")
	
	if result == true and inventory.get_item_quantity("health_potion") == 2:
		print("  ✓ PASS: Item used, quantity decreased\n")
		tests_passed += 1
	else:
		print("  ✗ FAIL: Expected 2 potions remaining, got ", inventory.get_item_quantity("health_potion"), "\n")
		tests_failed += 1
	
	teardown()
