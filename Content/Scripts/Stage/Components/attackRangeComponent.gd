extends Area2D

signal target_in
signal enqueue_target(object)

func _on_area_entered(area):
	if get_parent().get_node("stateComponent").get_Unit_tag() == "ally":
		if area.get_parent().get_node("stateComponent").get_Unit_tag() == "enemy":
			emit_signal("target_in")
			print("executed")
			emit_signal("enqueue_target", area)
	
	if get_parent().get_node("stateComponent").get_Unit_tag() == "enemy":
		if area.get_parent().get_node("stateComponent").get_Unit_tag() == "ally":
			emit_signal("target_in")
			emit_signal("enqueue_target", area)
