extends Node2D

var block_scene = preload("res://block.tscn")
var blocks = [] #Array to store references to block instances
var equation_sequence = []

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.block_pressed.connect(Callable(self, "_on_block_pressed"))

func _on_button_pressed():
	move_blocks_up()
	spawn_block_row()
	
func _on_block_pressed(blockType, blockValue):
	equation_sequence.append({"type": blockType, "value": blockValue})
	print(blockType + " " + str(blockValue) + "Block pressed - from game manager script")
	update_equation_text()

func spawn_block_row():
	for i in 6:
		var block = block_scene.instantiate()
		var block_type = randi_range(0, 1)  # 0 for number, 1 for operator
		add_child(block) 
		
		if block_type == 0: # Assign a random integer between -3 and 3 for number blocks
			block.blockType = "number"
			block.blockValue = randi_range(-3, 3)
		else:
			block.blockType = "operator"
			block.blockValue = randi_range(0, 3)
		
		block.position.x = 360 + i * 192
		block.position.y = 1920
		
		print("block created! Type:", block.blockType, "Value:", block.blockValue)
		
		block.add_to_group("blocks")
		blocks.append(block)
		
		var label = Label.new()
		var center_container = CenterContainer.new()
		
		if block.blockType == "number":
			label.text = str(block.blockValue)
		elif block.blockType == "operator":
		# Map numeric values to operator characters
			match block.blockValue:
				0: label.text = "+"  # Plus
				1: label.text = "-"  # Minus
				2: label.text = "x"  # Multiply
				3: label.text = "/"  # Divide
		
		label.label_settings = preload("res://LabelsforZeroSum.tres")
		label.z_index = -1
		label.horizontal_alignment = 1
		label.vertical_alignment = 1
		
		
		center_container.add_child(label)
		block.add_child(center_container)
		
func move_blocks_up():
	#move objects currently in existance up one row (192 pixels
	for block in blocks:
		block.position.y -= 192
		
func update_equation_text():
	var equation_string = ""
	for block in equation_sequence:
		if block["type"] == "operator":
			match block["value"]:
				0: equation_string += " + "
				1: equation_string += " - "
				2: equation_string += " * "  # Use "*" for multiplication
				3: equation_string += " / "
		else:
			equation_string += str(block["value"])  # Assuming numerical blocks
	
	$EquationText.text = equation_string
		
		
func deselect_block(block):
	var index_to_remove = equation_sequence.find(block)
	if index_to_remove != -1:
		equation_sequence.remove(index_to_remove)
		equation_sequence.resize(index_to_remove)
		update_equation_text()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

	
	

