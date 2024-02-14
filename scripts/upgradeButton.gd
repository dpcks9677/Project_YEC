extends Control

func _enter_tree():
	if get_name() == str("manaUpgradeButton"):
		get_node("TextureButton").texture_normal = load("res://sprites/UI/mana.png")
	if get_name() == str("popUpgradeButton"):
		get_node("TextureButton").texture_normal = load("res://sprites/UI/pop.png")
	if get_name() == str("attackUpgradeButton"):
		get_node("TextureButton").texture_normal = load("res://sprites/UI/att.png")

func _ready():
	pass # Replace with function body.

func _on_texture_button_pressed():
	modulate = Color(0.5, 0.5, 0.5, 1) #색조 변경 
	
	position.x -= 2
	position.y += 2
	
func _on_texture_button_button_up():
	print("pressed")
	modulate = Color(1, 1, 1, 1) #색조 변경 (원래대로) 

	position.x += 2
	position.y -= 2
