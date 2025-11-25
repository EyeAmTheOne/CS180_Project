class_name SceneTrigger extends Area2D

@export var connected_scene: String # Full path of scene to switch to

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		scene_manager.change_scene(get_owner(), connected_scene)
