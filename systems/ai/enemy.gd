extends CharacterBody2D
@onready var p = $"../Player";



const SPEED = 10

var target = null

func set_target(player: Node2D):
	target = player;

func _physics_process(delta: float) -> void:
	# If target exists, move towards target
	var direction = Vector2(0, 0);
	if target:
		direction = position.direction_to(target.position);
		
	velocity = direction * SPEED;
	move_and_slide();


func _on_detection_body_entered(body: Node2D) -> void:
	set_target(body);
