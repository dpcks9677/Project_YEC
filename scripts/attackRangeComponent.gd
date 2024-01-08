extends Area2D
class_name attackRangeComponent

@export var engage_Component: engageComponent

func _on_area_entered(area):
	#자기 공격범위가 인식이 되는 것 같음 
	engage_Component.attack_range_entered(area)

func _on_area_exited(area):
	engage_Component.attack_range_exited(area)
