extends CharacterBody2D

@export var speed = 100                      # how fast the player moves
@export var player_active : bool = true      # if false, player can't move
@onready var animated_sprite = $AnimatedSprite2D

var player_dead : bool = false               # track if death anim already played

# Diego added 
var wood: int = 0
var coal: int = 0
var gold: int = 0
var metal: int = 0                            
#### Diego code ends here


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed        # set movement based on input
	

func get_orientation():
	if velocity[0] > 0:
		# Look left
		animated_sprite.flip_h = false
	elif velocity[0] < 0:
		# Look right
		animated_sprite.flip_h = true

# Diego added ↓  
func add_wood(amount: int) -> void:
	wood += amount
	print("Picked up ", amount, " wood (Total: ", wood, ")")
<<<<<<< Updated upstream
=======
	_show_pickup_popup("+%d wood" % amount)
>>>>>>> Stashed changes

func add_coal(amount: int) -> void:
	coal += amount
	print("Picked up ", amount, " coal (Total: ", coal, ")")
<<<<<<< Updated upstream
=======
	_show_pickup_popup("+%d coal" % amount)
>>>>>>> Stashed changes

func add_gold(amount: int) -> void:
	gold += amount
	print("Picked up ", amount, " gold (Total: ", gold, ")")
<<<<<<< Updated upstream
=======
	_show_pickup_popup("+%d gold" % amount)
>>>>>>> Stashed changes

func add_metal(amount: int) -> void:
	metal += amount
	print("Picked up ", amount, " metal (Total: ", metal, ")")
<<<<<<< Updated upstream
 
#### Diego code ends here


func _physics_process(delta):	
=======
	_show_pickup_popup("+%d metal" % amount)
#### Diego code ends here


func _physics_process(_delta):
>>>>>>> Stashed changes
	if player_active:
		get_input()                         # handle movement input
		get_orientation()                   # flip sprite based on direction
		move_and_slide()                    # actually move the player

		# Diego added ↓  (interact with stuff like trees, rocks, etc)
		if Input.is_action_just_pressed("interact"):
			_try_interact()
		#### Diego code ends here
	
	if player_active:
		# handle animations while alive
		if !Input.get_vector("left", "right", "up", "down").is_zero_approx():
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
	else:
		# play death animation once
		if !player_dead:
			animated_sprite.play("death")
			player_dead = true


# Diego added ↓  (check everything inside the interact area and harvest if possible)
func _try_interact() -> void:
	for area in $InteractArea.get_overlapping_areas():
		var target = area.get_parent()
		if target.has_method("harvest"):
			target.harvest(self)            # pass the player to the harvest func
			return                          # stop after first valid target
#### Diego code ends here


func _on_player_health_health_depleted() -> void:
	player_active = false
	print("YOU HAVE DIED")
	
### new function 
# Diego added (shows pick up iteam)
func _show_pickup_popup(text: String) -> void:
	var ui = get_tree().get_first_node_in_group("ui")
	if ui:
		ui.show_pickup(text)
#### Diego code ends here
