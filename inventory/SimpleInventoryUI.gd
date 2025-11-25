extends CanvasLayer
# Minecraft-style hotbar at the bottom

@onready var hotbar = $Hotbar

var player
var inventory

func _ready():
	# Find player and inventory
	player = get_tree().get_first_node_in_group("player")
	
	if player and player.has_node("Inventory"):
		inventory = player.get_node("Inventory")
		inventory.inventory_changed.connect(update_hotbar)
	
	update_hotbar()

func update_hotbar():
	if not inventory:
		return
	
	# Clear old slots
	for child in hotbar.get_children():
		child.queue_free()
	
	# Create 9 slots (Minecraft style)
	var items = inventory.get_all_items()
	
	for i in range(9):
		var slot = Panel.new()
		slot.custom_minimum_size = Vector2(50, 50)
		
		# Style
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.3, 0.3, 0.3)
		style.border_width_left = 2
		style.border_width_right = 2
		style.border_width_top = 2
		style.border_width_bottom = 2
		style.border_color = Color(0.6, 0.6, 0.6)
		slot.add_theme_stylebox_override("panel", style)
		
		# Add item if exists
		if i < items.size():
			var item = items[i]
			
			# Item name at top
			var name_label = Label.new()
			name_label.text = item.get_name()
			name_label.position = Vector2(5, 5)
			name_label.add_theme_font_size_override("font_size", 10)
			name_label.add_theme_color_override("font_color", Color(1, 1, 1))
			slot.add_child(name_label)
			
			# Item quantity in bottom right
			var qty_label = Label.new()
			qty_label.text = str(item.get_quantity())
			qty_label.position = Vector2(30, 30)
			qty_label.add_theme_font_size_override("font_size", 16)
			qty_label.add_theme_color_override("font_color", Color(1, 1, 1))
			slot.add_child(qty_label)
		
		hotbar.add_child(slot)
