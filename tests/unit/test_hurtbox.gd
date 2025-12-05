extends GutTest

# Mock Health Resource/Class: Simulates the health logic.
class MockHealth extends Health:
	var damage_received: int = 0
	var healing_received: int = 0
	
	func take_damage(amount: int) -> void:
		damage_received += amount
		health = max(0, health - amount)
		
	func heal(amount: int) -> void:
		healing_received += amount
		health += amount

# Mock HitBox Class: Simulates the area that deals damage.
class MockHitBox extends HitBox:
	func _init(dmg: int):
		damage = dmg

# Mock HealBox Class: Simulates the area that provides healing.
class MockHealBox extends HealBox:
	func _init(heal: int):
		healing = heal


var hurt_box: HurtBox
var mock_health: MockHealth
var mock_hitbox: MockHitBox
var mock_healbox: MockHealBox

# Runs before each test function
func before_each():
	mock_health = MockHealth.new()
	mock_hitbox = MockHitBox.new(25)
	mock_healbox = MockHealBox.new(15)
	
	hurt_box = HurtBox.new()
	watch_signals(hurt_box)
	hurt_box.health = mock_health
	
	autofree(hurt_box)
	autofree(mock_hitbox)
	autofree(mock_health)
	autofree(mock_healbox)
	
	add_child(hurt_box)

# Runs after each test function
func after_each():
	hurt_box.queue_free()
	mock_health.queue_free()
	mock_hitbox.queue_free()
	mock_healbox.queue_free()


func test_damage_is_applied_and_signal_emitted():
	mock_health.health = 100
	var initial_health = mock_health.health

	# Directly call signal for hitbox
	hurt_box._on_area_entered_HIT(mock_hitbox)

	assert_eq(mock_health.health, initial_health - 25)
	assert_eq(mock_health.damage_received, 25)
	assert_signal_emitted(hurt_box, "received_damage")


func test_healing_is_applied_and_signal_emitted():
	# Start damaged
	mock_health.health = 50
	var initial_health = mock_health.health

	# Directly call signal for hitbox
	hurt_box._on_area_entered_HEAL(mock_healbox)

	assert_eq(mock_health.health, initial_health + 15)
	assert_eq(mock_health.healing_received, 15)
	assert_signal_emitted(hurt_box, "received_healing")
