extends Control

func _ready():
	get_node("laneSelector").text = str("btm")

func _on_lane_selector_toggled(toggled_on):
	if toggled_on == true:
		print("top")
		$laneSelector.text = "top"
	else:
		print("btm")
		$laneSelector.text = "btm"
