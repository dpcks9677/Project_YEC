extends NinePatchRect

@export var focusNode : NinePatchRect
@onready var focusImage = $SlotSelect

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(20):
		var slot = get_node("Slot"+str(i+1))
		slot.unitLoadoutButtonPressed.connect(_on_unitLoadoutButtonPressed)
		
		slot.itemName = SaveData.ownedUnitList[i][0]
		slot.itemID = SaveData.ownedUnitList[i][1]

func _process(delta):
	for i in range(20):
		var slot = get_node("Slot" + str(i+1))
		if SaveData.ownedUnitList[i][2] != 0:
			if slot.itemName == SaveData.ownedUnitList[i][0] and slot.itemID == SaveData.ownedUnitList[i][1]:
				slot.do_modulate(slot.get_node("TextureButton"))
				slot.get_node("TextureButton").disabled = true
		else:
			slot.get_node("TextureButton").disabled = false
			pass

#signal
func _on_unitLoadoutButtonPressed(position, node):
	focusImage.position = position #위치 반영 
	focusNode = node #노드 정보 받아옴

func get_focusNodeNull():
	if focusNode != null:
		return 1
	return focusNode
