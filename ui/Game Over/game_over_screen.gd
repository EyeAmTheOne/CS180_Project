extends CanvasLayer

func _ready():
	self.hide()


func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/menus/MainMenu.tscn")
	
	
func game_over():
	self.show()
	get_tree().paused = true
