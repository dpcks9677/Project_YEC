extends NinePatchRect

@export var focusNode : NinePatchRect
@onready var focusImage = $SlotSelect

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(20):
		get_node("Slot"+str(i+1)).unitLoadoutButtonPressed.connect(_on_unitLoadoutButtonPressed)

#signal
func _on_unitLoadoutButtonPressed(position, node):
	focusImage.position = position #위치 반영 
	focusNode = node #노드 정보 받아옴

func get_focusNodeNull():
	if focusNode != null:
		return 1
	return focusNode
