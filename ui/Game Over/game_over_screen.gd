extends CanvasLayer

func _ready():
	self.hide()


func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/menus/MainMenu.tscn")
	
	
func game_over():
	get_tree().paused = true
	get_node("Panel/HBoxContainer/GameOverScreenShowUpTimer").start()


func _on_game_over_screen_show_up_timer_timeout() -> void:
	self.show()
	get_node("Panel/HBoxContainer/RetryButton/RetryButtonShowUpTimer").start()
	get_node("Panel/HBoxContainer/MenuButton/MenuButtonShowUpTimer").start()
