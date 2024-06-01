extends NinePatchRect

@export var focusNode : NinePatchRect
@onready var focusImage = $SlotSelect

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(20):
		var slot = get_node("Slot"+str(i+1))
		slot.unitLoadoutButtonPressed.connect(_on_unitLoadoutButtonPressed)
		
		$SlotSelect.visible = false
		
		slot.itemName = SaveData.getOwnedUnitListName(i)
		slot.itemID = SaveData.getOwnedUnitListID(i)

func _process(_delta):
	for i in range(20):
		var slot = get_node("Slot" + str(i+1))
		if SaveData.getOwnedUnitListSlot(i) != 0: #유닛이 장착되있을 때 
			if slot.itemName == SaveData.getOwnedUnitListName(i) and slot.itemID == SaveData.getOwnedUnitListID(i):
				slot.do_modulate(slot.get_node("TextureButton"))
				slot.get_node("TextureButton").disabled = true
		else:
			slot.get_node("TextureButton").disabled = false
			slot.undo_modulate(slot.get_node("TextureButton"))
			pass

#signal
func _on_unitLoadoutButtonPressed(position, node):
	$SlotSelect.visible = true
	focusImage.position = position #위치 반영 
	focusNode = node #노드 정보 받아옴

func get_focusNodeNull():
	if focusNode != null:
		return 1
	return focusNode
