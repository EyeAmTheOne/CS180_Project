extends GutTest

var Health = preload("res://systems/health/health.gd")

var health: Health


func before_each():
	health = Health.new()
	watch_signals(health)

	add_child(health)
	
	autofree(health)
	
func after_each():
	health.queue_free()

# Test max health

func test_max_health_change_emits_signal():
	health.max_health = 150
	assert_eq(health.max_health, 150)
	assert_signal_emitted(health, "max_health_changed")


func test_max_health_clamped_to_minimum_1():
	health.max_health = 0
	assert_eq(health.max_health, 1)
	assert_signal_emitted(health, "max_health_changed")


func test_max_health_reducing_clamps_health():
	health.health = 50
	health.max_health = 20
	assert_eq(health.health, 20)

# Test damage and healing

func test_take_damage_reduces_health_and_emits_signal():
	health.take_damage(30)
	assert_eq(health.health, 70)
	assert_signal_emitted(health, "health_changed", -30)

func test_heal_increases_health_and_emits_signal():
	health.health = 50
	health.heal(30)
	assert_eq(health.health, 80)
	assert_signal_emitted(health, "health_changed", 30)

func test_health_clamped_to_zero_and_emits_depleted():
	health.take_damage(4000)
	assert_eq(health.health, 0)
	assert_signal_emitted(health, "health_depleted")

# Test invulnerability

func test_damage_ignored_while_invulnerable():
	health.invulnerability = true
	health.health = 100

	health.take_damage(50)

	# No damage should be taken
	assert_eq(health.health, 100)
	assert_signal_not_emitted(health, "health_changed")


func test_invulnerability_starts_after_damage():
	health.invulnerability = false
	health.take_damage(10)

	assert_eq(health.invulnerability, true)  # Should be set right after taking damage


func test_temporary_invulnerability_connects_timeout():
	health.set_temporary_invulnerability(2.0)

	# Make the invulnerability timer run out
	health.invulnerability_timer.timeout.emit()

	# Should no longer be invulnerable
	assert_eq(health.invulnerability, false)


# Test edge cases for set health

func test_set_health_does_not_emit_if_same_value():
	health.health = health.health   # no change
	assert_signal_not_emitted(health, "health_changed")


func test_health_clamps_above_max():
	health.health = 999
	assert_eq(health.health, health.max_health)


func test_health_clamps_below_zero():
	health.health = -100
	assert_eq(health.health, 0)
	assert_signal_emitted(health, "health_depleted")
