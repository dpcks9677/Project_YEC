extends Control
class_name unitButton

@export var unitName : String
@export var unitRes : statusResource
@export var img : Texture2D

func _enter_tree():
	if get_name() == str("unitButton1") and get_parent().unitName[0] != null:
		unitName = get_parent().unitName[0]
	if get_name() == str("unitButton2") and get_parent().unitName[1] != null:
		unitName = get_parent().unitName[1]
	if get_name() == str("unitButton3") and get_parent().unitName[2] != null:
		unitName = get_parent().unitName[2]
	if get_name() == str("unitButton4") and get_parent().unitName[3] != null:
		unitName = get_parent().unitName[3]
		
	if unitName != "":
		unitRes = load("res://Content/Scripts/Resources/" + str(unitName) + ".tres")

func _ready():
	#버튼에 아무것도 없으면 빈버튼 스프라이트를 출력하도록 설계할 것. (리소스 만들어야 함)
	img = load("res://Content/Graphics/Sprites/portrait/" + str(unitName) + ".png")
	if img != null: #유닛 정보가 있을 때 
		get_node("TextureButton").texture_normal = img
		get_node("manaTag").get_node("mana").set_text(str(unitRes.mana))
	else: #유닛 정보가 없을 때 (슬롯에 유닛을 넣지 않았을 때) 
		remove_child(get_node("manaTag"))
		get_node("TextureButton").disabled = true
		modulate = Color(0.3, 0.3, 0.3, 1) #비활성화 톤 

func _on_texture_button_pressed():
	modulate = Color(0.5, 0.5, 0.5, 1) #색조 변경 
	
	position.x -= 3
	position.y += 3
	

func _on_texture_button_button_up():
	print("pressed")
	get_parent().spawn(unitName)
	modulate = Color(1, 1, 1, 1) #색조 변경 (원래대로) 

	position.x += 3
	position.y -= 3
