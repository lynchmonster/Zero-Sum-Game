extends Area2D

# Inside your block script

var blockType : String
var blockValue : int

func _ready():
	set_process_input(true)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("from block script Type:", blockType, "Value:", blockValue)
		SignalManager.block_pressed.emit(blockType, blockValue)
		toggle_color()

func toggle_color():
# Toggle the color between default and the pressed state
	print ("block color has been toggled")
	if self.modulate == Color(1, 1, 1, 1):
		# If the color is default, set the pressed color
		self.modulate = Color(0.5, 0.5, 0.5, 1)
	else:
		# If the color is pressed, set it back to default
		self.modulate = Color(1, 1, 1, 1)
		


