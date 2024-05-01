extends Area2D

signal enqueue_target(object)

func _on_area_entered(area):
	if get_parent().get_node("stateComponent").get_Unit_tag() == "ally":
		if area.get_name() == "hitbox" and area.get_parent().get_node("stateComponent").get_Unit_tag() == "enemy":
			emit_signal("enqueue_target", area)
	
	if get_parent().get_node("stateComponent").get_Unit_tag() == "enemy":
		if area.get_name() == "hitbox" and area.get_parent().get_node("stateComponent").get_Unit_tag() == "ally":
			emit_signal("enqueue_target", area)
