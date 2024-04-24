extends Control

func _ready():
	print("scene started")
	get_node("transition/ColorRect").visible = true
	get_node("transition").play("fade_in")
	
func _on_stage_1_pressed():
	var tween = create_tween()
	tween.tween_property($screen, "position", Vector2(576,324), 0.2)

func _on_Tween_tween_completed(object, key):
	print("Movement completed!")
	
