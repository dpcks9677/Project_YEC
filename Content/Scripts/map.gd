extends Control

@onready var camera = $Camera2D

var isButtonMove : bool = false
var target_pos : Vector2
var move_speed = 5.0

# Variables to track dragging
var dragging = false
var last_mouse_position = Vector2()

# Tolerance for position comparison
var tolerance = 20.0

func _ready():
	print("scene started")
	get_node("transition/ColorRect").visible = true
	get_node("transition").play("fade_in")
	
	set_process_input(true)
	
func _process(delta):
	#카메라 관련 코드 
	if isButtonMove:
		camera.position = camera.position.lerp(target_pos, move_speed * delta) #카메라 부드럽게 이동 
		if camera.position.distance_to(target_pos) < tolerance: #버튼과 카메라 좌표를 비교해서 오차범위 내면 이동 종료 
			isButtonMove = false
			print("move end")

func _input(event): #카메라 드래그 관련 함수 
	if event is InputEventMouseButton:
		if event.button_index == 1: #MouseButton.LEFT == 1
			if event.is_pressed():
				# Start dragging
				dragging = true
				
				slide_tween_out() # HUD 회수 
				
				last_mouse_position = event.position
			else:
				# Stop dragging
				dragging = false
	elif event is InputEventMouseMotion:
		if dragging:
			# Calculate the drag offset
			var offset = event.position - last_mouse_position
			# Update the camera position
			camera.position -= offset
			# Update the last mouse position
			last_mouse_position = event.position

func slide_tween_in():
	var tween = create_tween()
	tween.tween_property($stageInfoHUD/Sprite2D, "position", Vector2(15, 0), 0.3)

func slide_tween_out():
	var tween = create_tween()
	tween.tween_property($stageInfoHUD/Sprite2D, "position", Vector2(-432, 0), 0.1)

#signal
func _on_stage_1_pressed():
	slide_tween_in()
	
	isButtonMove = true
	var button_position = get_node("stage1").get_global_position()
	target_pos = button_position

func _on_stage_2_pressed():
	slide_tween_in()
	
	isButtonMove = true
	var button_position = get_node("stage2").get_global_position()
	target_pos = button_position


func _on_stage_3_pressed():
	slide_tween_in()
	
	isButtonMove = true
	var button_position = get_node("stage3").get_global_position()
	target_pos = button_position


func _on_Tween_tween_completed(object, key):
	print("Movement completed!")
	
