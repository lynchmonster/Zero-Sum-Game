extends Label

var equation_text = 

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.block_pressed.connect(update_equation_text)

func update_equation_text(blockType, blockValue):
	print(blockType + " " + str(blockValue) + "Block pressed - from equation manager script")
	
	# Get the current text of the EquationText label
	equation_text.text = " " + "blockType" + " " + "blockValue" + " "
	
