extends GutTest

var enemy
var dummy_target

func before_each():
	# Load enemy scene
	var EnemyScene = load("res://systems/ai/Enemy.tscn")
	enemy = EnemyScene.instantiate()
	dummy_target = Node2D.new()

	# Free automatically
	autofree(enemy)
	autofree(dummy_target)

func test_set_target():
	enemy.set_target(dummy_target)
	assert_eq(enemy.target, dummy_target, "Enemy did not store target correctly")

	
