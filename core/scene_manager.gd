class_name SceneManager extends Node

var player: Player
var old_scene_name: String

# Scene changing logic, passing old scene and path of new scene
func change_scene(from, to: String):
	old_scene_name = from.name
	player = from.get_node("./Player")
	player.get_parent().remove_child(player)
	
	from.get_tree().call_deferred("change_scene_to_file", to)
