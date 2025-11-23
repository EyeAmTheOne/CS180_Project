class_name BaseScene extends Node

@onready var player: Player = $Player
@onready var entrance_markers: Node2D = $EntranceMarkers


# On entering scene tree, remove player from old scene and add it to this scene
func _ready() -> void:
	if scene_manager.player:
		if player:
			player.queue_free()
			
		player = scene_manager.player
		add_child(player)
		
		position_player()

# Place player in the position marked by the entrance marker of the new scene
func position_player() -> void:
	# Get the name of previous scene
	var old_scene_name = scene_manager.old_scene_name
	if old_scene_name.is_empty():
		old_scene_name = "any"
		
	# Get spawn location, named after old scene
	for spawn_location in entrance_markers.get_children():
		if spawn_location is Marker2D and spawn_location.name == old_scene_name or spawn_location.name == "any":
			player.global_position = spawn_location.global_position
