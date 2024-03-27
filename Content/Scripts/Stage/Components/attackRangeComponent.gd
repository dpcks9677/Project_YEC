extends Area2D
class_name attackRangeComponent

@export var engage_Component: engageComponent

func _on_area_entered(area):
	engage_Component.attack_range_entered(area)
