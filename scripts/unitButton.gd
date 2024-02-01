extends Control
class_name unitButton

@export var unitName : String
@export var img : Texture2D

func _init():
	pass

func _enter_tree():
	if get_name() == str("unitButton1"):
		unitName = get_parent().slot_1_Unit
	if get_name() == str("unitButton2"):
		unitName = get_parent().slot_2_Unit
	if get_name() == str("unitButton3"):
		unitName = get_parent().slot_3_Unit
	if get_name() == str("unitButton4"):
		unitName = get_parent().slot_4_Unit

func _ready():
	img = load("res://sprites/portrait/" + str(unitName) + ".png")
	get_node("TextureButton").texture_normal = img

func _on_texture_button_pressed():
	modulate = Color(0.6, 0.6, 0.6, 1) #색조 변경 
	
	position.x -= 3
	position.y += 3
	

func _on_texture_button_button_up():
	print("pressed")
	modulate = Color(1, 1, 1, 1) #색조 변경 (원래대로) 

	position.x += 3
	position.y -= 3
