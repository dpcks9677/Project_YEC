extends Control

@export var currentLane : bool # false = top, true = bottom

func _ready():
	get_node("laneSelector").text = str("btm")
	currentLane = true

func _on_lane_selector_toggled(toggled_on):
	if toggled_on == true:
		print("top")
		$laneSelector.text = "top"
		currentLane = false
	else:
		print("btm")
		$laneSelector.text = "btm"
		currentLane = true
