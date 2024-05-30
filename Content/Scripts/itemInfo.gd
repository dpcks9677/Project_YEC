extends NinePatchRect

@onready var unitLoadout = $"../unitLoadout"
var itemName

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if unitLoadout.focusNode != null:
		itemName = unitLoadout.focusNode.get_itemName()
