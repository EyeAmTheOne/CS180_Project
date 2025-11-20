extends Node2D

var looted: bool = false
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func harvest(player):
	if looted:
		print("Chest empty.")
		return

	# Random loot rolls
	var wood_amount = roll_wood()
	var coal_amount = roll_coal()
	var gold_amount = roll_gold()

	# Give loot to player
	player.add_wood(wood_amount)
	player.add_coal(coal_amount)
	player.add_gold(gold_amount)

	looted = true

	print("You looted the chest!")
	print("Loot: ",
		wood_amount, " wood, ",
		coal_amount, " coal, ",
		gold_amount, " gold."
	)
	

# -----------------------
# RANDOM ROLL FUNCTIONS
# -----------------------

# Max wood = 25
func roll_wood():
	var roll = rng.randi_range(1, 100)

	if roll <= 50:        # common
		return rng.randi_range(3, 8)
	elif roll <= 80:      # uncommon
		return rng.randi_range(8, 15)
	elif roll <= 95:      # rare
		return rng.randi_range(15, 20)
	else:                 # super rare
		return rng.randi_range(20, 25)


# Max coal = 15
func roll_coal():
	var roll = rng.randi_range(1, 100)

	if roll <= 60:
		return rng.randi_range(1, 5)
	elif roll <= 90:
		return rng.randi_range(5, 10)
	else:
		return rng.randi_range(10, 15)


# Max gold = 5
func roll_gold():
	var roll = rng.randi_range(1, 100)

	if roll <= 85:
		return 0  # most chests drop no gold
	elif roll <= 97:
		return rng.randi_range(1, 3)
	else:
		return rng.randi_range(3, 5)
