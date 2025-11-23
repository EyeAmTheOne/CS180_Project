extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


func _on_menu_button_show_up_timer_timeout() -> void:
	self.show()
