extends Control

func _ready():
	get_node("laneSelector").button_pressed = true
	
func _on_lane_selector_toggled(toggled_on):
	if toggled_on == true:
		print("top")
		get_node("laneSelector").text = str("top")
	else:
		print("btm")
		get_node("laneSelector").text = str("btm")
