extends CharacterBody2D

@export var speed = 100
@export var player_active : bool = true
@onready var animated_sprite = $AnimatedSprite2D
@onready var animated_player = $AnimationPlayer
@onready var hitbox = $HitBox/CollisionShape2D

var player_dead : bool = false
var current_attack : bool = false
var stun : bool = false

# Diego resources
var wood: int = 0
var coal: int = 0
var gold: int = 0
var metal: int = 0

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func get_orientation():
	if velocity[0] > 0:
		# Look left
		animated_sprite.flip_h = false
		# Flip weapon hitbox to the left
		hitbox.position[0] = abs(hitbox.position[0])
	elif velocity[0] < 0:
		# Look right
		animated_sprite.flip_h = true
		# Flip weapon hitbox to the right
		hitbox.position[0] = -abs(hitbox.position[0])

# Diego: resource gain + popup
func add_wood(amount: int) -> void:
	wood += amount
	print("Picked up ", amount, " wood (Total: ", wood, ")")
	_show_pickup_popup("+%d wood" % amount)

func add_coal(amount: int) -> void:
	coal += amount
	print("Picked up ", amount, " coal (Total: ", coal, ")")
	_show_pickup_popup("+%d coal" % amount)

func add_gold(amount: int) -> void:
	gold += amount
	print("Picked up ", amount, " gold (Total: ", gold, ")")
	_show_pickup_popup("+%d gold" % amount)

func add_metal(amount: int) -> void:
	metal += amount
	print("Picked up ", amount, " metal (Total: ", metal, ")")
	_show_pickup_popup("+%d metal" % amount)

func _physics_process(delta):
	if player_active:
		get_input()
		get_orientation()

		# handle attack input
		if !current_attack and !stun:
			if Input.is_action_just_pressed("attack"):
				current_attack = true
				attack_animation()

		move_and_slide()

		# Diego: interact with trees/rocks/chest/etc
		if Input.is_action_just_pressed("interact"):
			_try_interact()

		# movement animation (walk / idle) when not attacking / stunned
		if !current_attack and !stun:
			if !Input.get_vector("left", "right", "up", "down").is_zero_approx():
				animated_sprite.play("walk")
			else:
				animated_sprite.play("idle")
	else:
		if !player_dead:
			animated_sprite.play("death")
			player_dead = true

func attack_animation():
	if current_attack:
		animated_player.play("Attack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack":
		current_attack = false
	elif anim_name == "Hurt":
		stun = false
		current_attack = false

# Diego: try to harvest something inside InteractArea
func _try_interact() -> void:
	for area in $InteractArea.get_overlapping_areas():
		var target = area.get_parent()
		if target.has_method("harvest"):
			target.harvest(self)
			return

func _on_player_health_health_depleted() -> void:
	player_active = false
	get_node("GameOverScreen").game_over()

func _on_hurt_box_received_damage(damage: int) -> void:
	if player_active:
		stun = true
		animated_player.play("Hurt")

# Diego: show UI popup when picking up items
func _show_pickup_popup(text: String) -> void:
	var ui = get_tree().get_first_node_in_group("ui")
	if ui:
		ui.show_pickup(text)
