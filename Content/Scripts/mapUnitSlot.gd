extends NinePatchRect

@export var idx : int

@export var itemNameArr : Array
@export var itemName : String

@export var unitRes : Resource

signal unitLoadoutButtonPressed

func _ready():
	#idx 부여 
	for i in range(get_parent().get_child_count()): #버튼은 1~20, idx는 0~19
		if get_name() == "Slot" + str(i):
			idx = i - 1
			if get_parent().get_name() == "unitLoadout":
				itemName = SaveData.ownedUnitList[idx][0]
			elif get_parent().get_name() == "ownedTowerList":
				itemName = SaveData.ownedTowerList[idx][0]
			elif get_parent().get_name()  == "itemEquipped":
				itemName = SaveData.equippedList[idx][0]
	
	if itemName != "":
		unitRes = load("res://Content/Scripts/Resources/unitData/" + itemName + ".tres")
		
		$TextureButton/Sprite2D.texture = load("res://Content/Graphics/Sprites/portrait/" + itemName + ".png")
		$TextureButton/manaTag/mana.text = str(unitRes.mana)
	else:
		$TextureButton.disabled = true
		$TextureButton/manaTag.visible = false
		$Area2D/CollisionShape2D.disabled = true
		
	if get_parent().get_name() == "itemEquipped":
		$Area2D/CollisionShape2D.disabled = false

func _process(delta):
	if itemName != "": #runtime중 itemName 데이터가 들어왔을 때 
		unitRes = load("res://Content/Scripts/Resources/unitData/" + itemName + ".tres")
		
		$TextureButton/Sprite2D.texture = load("res://Content/Graphics/Sprites/portrait/" + itemName + ".png")
		$TextureButton/manaTag/mana.text = str(unitRes.mana)
		$TextureButton/manaTag.visible = true

func do_modulate(button : TextureButton):
	button.modulate = Color(0.5, 0.5, 0.5, 1) #색조 변경 
	button.position.x = 4
	button.position.y = 8
	
func undo_modulate(button : TextureButton):
	button.modulate = Color(1, 1, 1, 1) #색조 변경 (원래대로) 
	button.position.x = 6
	button.position.y = 6

#getter
func get_itemName():
	return itemName

#signal
func _on_texture_button_button_down():
	do_modulate($TextureButton)

func _on_texture_button_button_up():
	undo_modulate($TextureButton)	
	
func _on_texture_button_pressed():
	emit_signal("unitLoadoutButtonPressed", position, self)

