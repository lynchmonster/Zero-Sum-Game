extends Node2D

var block_scene = preload("res://block.tscn")
var blocks = [] #Array to store references to block instances

var equation_sequence = [] #Array to store order of blocks in equation
@export var turn_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.block_pressed.connect(Callable(self, "_on_block_pressed"))

func _on_button_pressed():
	equation_check()
	move_blocks_up()
	spawn_block_row()
	turn_number += 1
	
func _on_block_pressed(block, blockType, blockValue):
	var index_to_remove = -1
	print("Deselected block:", block)
	for i in range(equation_sequence.size()):
		print("Array block:", equation_sequence[i]["block"])
		if equation_sequence[i]["block"] == block:
			index_to_remove = i
			break
			
	if index_to_remove != -1:
		print("Before erase:", equation_sequence)
		equation_sequence.remove_at(index_to_remove)
		print("After erase:", equation_sequence)
		update_equation_text()
		print("index to remove - it should have updated text before this")
	else:
		equation_sequence.append({"block": block, "type": blockType, "value": blockValue})
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
				2: label.text = "*"  # Multiply
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
	print("Before setting text:", $EquationText.text)
	$EquationText.text = ""
	print("After setting text:", $EquationText.text)
	var equation_string = "" #need to make this equal to the value of all blocks in the equation_sequence array
	
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
		
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
	
func equation_check():
	var equation_check_string = $EquationText.text
	var expression = Expression.new()
	expression.parse(equation_check_string)
	var result = expression.execute()
	if result == 0:
		print("Equation equals zero!")
		# Perform actions for zero equation
	else:
		print("Equation doesn't equal zero.")
		# Handle non-zero equation
# Handle the error appropriately, e.g., display an error message

