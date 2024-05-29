extends NinePatchRect

@onready var unitLoadout = $"../unitLoadout"

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(8):
		var child = get_node("Slot" + str(i+1))
		child.itemEquip.connect(_on_itemEquip)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(8):
		var slot = get_node("Slot" + str(i+1))
		if SaveData.ownedUnitList[i][2] != 0:
			slot.itemName = SaveData.ownedUnitList[i][0]
			slot.itemID = SaveData.ownedUnitList[i][1]
			slot.get_node("TextureButton").disabled = false
			

#signal
func _on_itemEquip(name, data): #시그널 받았을 시, 슬롯 위치에 따라 ownedUnitList의 isEquip 정보 수정 
	for i in range(8):
		if name == "Slot" + str(i+1): #data 0 = itemName, 1 = itemID
			for j in range(20):
				if SaveData.ownedUnitList[j][0] == data[0] and SaveData.ownedUnitList[j][1] == data[1]:
					SaveData.ownedUnitList[j][2] = i
					print(SaveData.ownedUnitList[j])
