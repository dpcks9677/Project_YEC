extends Control

@export var unitName : String

func _ready():
	unitName = "knight"

func _on_texture_button_pressed():
	modulate = Color(0.6, 0.6, 0.6, 1) #색조 변경 
	
	position.x -= 3
	position.y += 3
	

func _on_texture_button_button_up():
	print("pressed")
	modulate = Color(1, 1, 1, 1) #색조 변경 (원래대로) 

	position.x += 3
	position.y -= 3
