extends Control

@export var currentLane : bool # false = top, true = bottom

func _ready():
	get_node("laneSelector").text = str("top")
	get_node("laneSelector").button_pressed = true

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_X:
			get_node("laneSelector").button_pressed = !get_node("laneSelector").button_pressed
			currentLane = !currentLane

func _on_lane_selector_toggled(toggled_on):
	if get_node("laneSelector").button_pressed == false:
		print("btm")
		$laneSelector.text = "btm"
	else:
		print("top")
		$laneSelector.text = "top"
