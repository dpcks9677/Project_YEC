extends NinePatchRect

@onready var focus = $SlotSelect

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(20):
		get_node("Slot"+str(i+1)).unitLoadoutButtonPressed.connect(_on_unitLoadoutButtonPressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#signal
func _on_unitLoadoutButtonPressed(position):
	focus.position = position
