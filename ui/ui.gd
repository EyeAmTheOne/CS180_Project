extends CanvasLayer

@onready var pickup_label: Label = $PickupLabel
var popup_time := 1.2

func _ready() -> void:
	pickup_label.visible = false
	add_to_group("ui")

func show_pickup(text: String) -> void:
	pickup_label.text = text
	pickup_label.visible = true

	var t = get_tree().create_timer(popup_time)
	await t.timeout
	pickup_label.visible = false
