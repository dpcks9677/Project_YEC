extends Control

signal manaUpgrade
signal popUpgrade
signal attackUpgrade

@export var state : String

func _enter_tree():
	if get_name() == str("manaUpgradeButton"):
		state = "mana"
		get_node("TextureButton").texture_normal = load("res://sprites/UI/mana.png")
	if get_name() == str("popUpgradeButton"):
		state = "pop"
		get_node("TextureButton").texture_normal = load("res://sprites/UI/pop.png")
	if get_name() == str("attackUpgradeButton"):
		state = "attack"
		get_node("TextureButton").texture_normal = load("res://sprites/UI/att.png")

func _physics_process(_delta):
	#업그레이드 진행 시 버튼 비활성화 
	if state == "mana" and get_parent().get_parent().get_parent().isManaUpgrade == true:
		get_node("TextureButton").set_disabled(true)
		upgradeProgressTexture()
	elif state == "pop" and get_parent().get_parent().get_parent().isPopUpgrade == true:
		get_node("TextureButton").set_disabled(true)
		modulateDown()
	elif state == "attack" and get_parent().get_parent().get_parent().isAttackUpgrade == true :
		get_node("TextureButton").set_disabled(true)
		modulateDown()

func modulateDown():
	modulate = Color(0.5, 0.5, 0.5, 1) #색조 변경 

func modulateUp():
	modulate = Color(1, 1, 1, 1) #색조 변경 (원래대로) 
	
func upgradeProgressTexture():
	$UpgradeProgress.set_visible(true) #sprite on
	for i in range(20):
		await get_tree().create_timer(1.0).timeout
		$UpgradeProgress.set_value($UpgradeProgress.get_value()-2.25)

func _on_texture_button_pressed():
	modulateDown()
	position.x -= 2
	position.y += 2
	
func _on_texture_button_button_up():
	modulateUp()
	position.x += 2
	position.y -= 2
	
	#upgrade 버튼 상호작용시 resourceHandler에게 signal 방출 
	if state == "mana":
		emit_signal("manaUpgrade")
	elif state == "pop":
		emit_signal("popUpgrade")
	elif state == "attack":
		emit_signal("attackUpgrade")
