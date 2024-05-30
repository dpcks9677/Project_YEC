extends NinePatchRect

@onready var unitLoadout = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(8):
		var child = get_node("Slot" + str(i+1))
		child.itemEquip.connect(_on_itemEquip)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in range(20):
		if SaveData.ownedUnitList[i][2] != 0: #장착된 유닛일 때 
			var idx = SaveData.ownedUnitList[i][2] #유닛이 들어갈 위치 
			var slot = get_node("Slot" + str(idx)) #버튼 위치 
			
			slot.itemName = SaveData.ownedUnitList[i][0]
			slot.itemID = SaveData.ownedUnitList[i][1]
			slot.itemSlotIdx = SaveData.ownedUnitList[i][2]
			
			slot.get_node("TextureButton").disabled = false
			
	for i in range(8): #유닛이 알맞게 들어갔는지 검사 
		var slot = get_node("Slot" + str(i+1)) #itemEquip 하위 노드들 
		#슬롯에 든 데이터 검사
		for j in range(20): #데이터셋에 접근 
			if SaveData.ownedUnitList[j][0] == slot.itemName and SaveData.ownedUnitList[j][1] == slot.itemID:
				if SaveData.ownedUnitList[j][2] == i+1:
					pass
				else:
					slot.itemName = ""
					slot.itemID = 0

#signal
func _on_itemEquip(name, data): #시그널 받았을 시, 슬롯 위치에 따라 ownedUnitList의 isEquip 정보 수정 
	for i in range(8):
		if name == "Slot" + str(i+1): #data 0 = itemName, 1 = itemID
			for j in range(20):
				if SaveData.ownedUnitList[j][0] == data[0] and SaveData.ownedUnitList[j][1] == data[1]:
					SaveData.ownedUnitList[j][2] = i+1
