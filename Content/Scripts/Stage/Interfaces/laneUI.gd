extends Control

@export var currentLane : bool # false = top, true = bottom

func _ready():
	get_node("laneSelector").text = str("btm")
	get_node("laneSelector").button_pressed = true
	currentLane = true

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_X:
			if currentLane == true:
				currentLane = false
			else:
				currentLane = true
			get_node("laneSelector").button_pressed = !get_node("laneSelector").button_pressed

func _on_lane_selector_toggled(toggled_on):
	if get_node("laneSelector").button_pressed == true:
		print("btm")
		$laneSelector.text = "btm"
		currentLane = true
	else:
		print("top")
		$laneSelector.text = "top"
		currentLane = false
