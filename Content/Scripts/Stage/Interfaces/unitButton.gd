extends NinePatchRect
class_name unitButton

@export var unitName : String
@export var unitRes : statusResource
@export var img : Texture2D

var elapsed_time : float = 0.0
var cooltime : int
var isCooldown : bool

func _enter_tree():
	if get_name() == str("unitButton1") and get_parent().unitName[0] != null:
		unitName = get_parent().unitName[0]
	if get_name() == str("unitButton2") and get_parent().unitName[1] != null:
		unitName = get_parent().unitName[1]
	if get_name() == str("unitButton3") and get_parent().unitName[2] != null:
		unitName = get_parent().unitName[2]
	if get_name() == str("unitButton4") and get_parent().unitName[3] != null:
		unitName = get_parent().unitName[3]
	if get_name() == str("unitButton5") and get_parent().unitName[4] != null:
		unitName = get_parent().unitName[4]
	if get_name() == str("unitButton6") and get_parent().unitName[5] != null:
		unitName = get_parent().unitName[5]
	if get_name() == str("unitButton7") and get_parent().unitName[6] != null:
		unitName = get_parent().unitName[6]
	if get_name() == str("unitButton8") and get_parent().unitName[7] != null:
		unitName = get_parent().unitName[7]
		
	if unitName != "":
		unitRes = load("res://Content/Scripts/Resources/unitData/" + str(unitName) + ".tres")

func _ready():
	#버튼에 아무것도 없으면 빈 버튼 스프라이트를 출력하도록 설계할 것. (리소스 만들어야 함)
	img = load("res://Content/Graphics/Sprites/portrait/" + str(unitName) + ".png")
	if img != null: #유닛 정보가 있을 때 
		$TextureButton/Sprite2D.texture = img
		$TextureButton/manaTag/mana.set_text(str(unitRes.mana))
	else: #유닛 정보가 없을 때 (슬롯에 유닛을 넣지 않았을 때) 
		$TextureButton/manaTag.visible = false
		$TextureButton.disabled = true
		modulate = Color(0.3, 0.3, 0.3, 1) #비활성화 톤 
		
	#쿨다운 비주얼라이징 	
	$TextureProgressBar.visible = false
	
	#쿨다운 정보 저장 
	if unitRes:
		cooltime = unitRes.cooltime
	$TextureProgressBar.max_value = cooltime
	$TextureProgressBar.value = cooltime
	
	set_process(false)

func _process(delta):
	if isCooldown:
		$TextureProgressBar.visible = true
		$TextureButton.disabled = true #버튼 비활성화 
		elapsed_time += delta
		if elapsed_time >= cooltime:
			elapsed_time = cooltime
			isCooldown = false
			$TextureButton.disabled = false #버튼 활성화 
			$TextureProgressBar.value = cooltime #progressBar value 초기화 
			$TextureProgressBar.visible = false #progressBar 숨기기 
			elapsed_time = 0 #초기화 
			set_process(false)
			
		$TextureProgressBar.value = cooltime - elapsed_time
		

func _on_texture_button_pressed():
	modulate = Color(0.5, 0.5, 0.5, 1) #색조 변경 
	
	$TextureButton/Sprite2D.position.x -= 3
	$TextureButton/Sprite2D.position.y += 3
		
	
func _on_texture_button_button_up():
	get_parent().spawn(unitName)
	modulate = Color(1, 1, 1, 1) #색조 변경 (원래대로) 

	$TextureButton/Sprite2D.position.x += 3
	$TextureButton/Sprite2D.position.y -= 3

	isCooldown = true
	set_process(true)
