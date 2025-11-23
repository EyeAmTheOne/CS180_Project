extends Button

func _ready():
	self.hide()
	

func _on_retry_button_show_up_timer_timeout() -> void:
	self.show()
