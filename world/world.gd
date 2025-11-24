extends BaseScene

@onready var camera: Camera2D = $PlayerCamera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	camera.follow_node = player
