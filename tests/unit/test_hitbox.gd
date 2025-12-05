extends "res://addons/gut/test.gd"

var HitBox = preload("res://systems/health/hitbox.gd")

var hitbox: HitBox
var collision_shape: CollisionShape2D


func before_each():
	hitbox = HitBox.new()
	collision_shape = CollisionShape2D.new()
	collision_shape.disabled = false  # should automatically flip when added to scene tree
	collision_shape.name = "CollisionShape2D"
	hitbox.add_child(collision_shape)
	
	autofree(hitbox)
	autofree(collision_shape)

	# run _ready() inside the hitbox script by adding object to scene tree and waiting for a frame
	add_child(hitbox)   
	wait_physics_frames(1)

func after_each():
	hitbox.queue_free()


func test_collision_shape_disabled_in_ready():
	assert_true(collision_shape.disabled,
		"CollisionShape2D should be disabled by default in _ready()")

func test_default_damage():
	assert_eq(hitbox.damage, 25)

func test_set_damage_changes_property():
	hitbox.damage = 40
	assert_eq(hitbox.damage, 40)

func test_set_and_get_damage_methods():
	hitbox.set_damage(55)
	assert_eq(hitbox.get_damage(), 55)
