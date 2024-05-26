extends NinePatchRect

@export var idx : int

@export var unitNameArr : Array
@export var unitName : String

@export var unitRes : Resource

func _ready():
	#idx 부여 
	for i in range(20): #버튼은 1~20, idx는 0~19
		if get_name() == "unitSlot" + str(i):
			idx = i - 1
			unitName = SaveData.ownedUnitList[idx]
	
	if unitName != "":
		unitRes = load("res://Content/Scripts/Resources/unitData/" + unitName + ".tres")
		
		$TextureButton/Sprite2D.texture = load("res://Content/Graphics/Sprites/portrait/" + unitName + ".png")
		$TextureButton/manaTag/mana.text = str(unitRes.mana)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_texture_button_pressed():
	print("pressed")
