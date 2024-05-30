extends NinePatchRect

@export var idx : int

@export var itemName : String
@export var itemID : int

@export var unitRes : Resource

var dragging : bool

var has_run_once : bool

signal unitLoadoutButtonPressed
signal itemEquip

func _ready():
	set_process_input(true)

func _input(event): 
	if event is InputEventMouseButton:
		if event.button_index == 1: #MouseButton.LEFT == 1 / 드래그 했다가 풀었을 때 트리거 
			if event.is_pressed():
				# Start dragging
				dragging = true
			else:
				# Stop dragging
				undo_modulate($TextureButton)

func _gui_input(event):
	if event is InputEventMouseButton: #더블클릭 
		if event.double_click == true:
			if get_parent().get_name() == "itemEquipped":
				for i in range(20):
					if SaveData.ownedUnitList[i][0] == itemName and SaveData.ownedUnitList[i][1] == itemID: 
						SaveData.ownedUnitList[i][2] = 0 
						itemName = ""
						itemID = 0
						$TextureButton/Sprite2D.texture = null

func _process(delta):
	if itemName != "" and itemID != 0:
		has_run_once = true
		unitRes = load("res://Content/Scripts/Resources/unitData/" + itemName + ".tres")
		
		$TextureButton/Sprite2D.texture = load("res://Content/Graphics/Sprites/portrait/" + itemName + ".png")
		$TextureButton/manaTag/mana.text = str(unitRes.mana)
		$TextureButton/manaTag.visible = true
	elif itemName == "" and itemID == 0:
		has_run_once = true
		$TextureButton.disabled = true
		$TextureButton/manaTag.visible = false
		#$Area2D/CollisionShape2D.disabled = true

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
	
func _on_texture_button_input_data(name, data):
	print(name, data) 
	emit_signal("itemEquip", name, data)
