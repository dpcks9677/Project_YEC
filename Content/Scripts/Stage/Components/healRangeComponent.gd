extends Area2D

signal enqueue_target(object)

#같은 팩션이여야 target이 되도록 코드 작성 
func _on_area_entered(area):
	if get_parent().get_node("stateComponent").get_faction() == "ally":
		if area.get_name() == "hitbox" and area.get_parent().get_node("stateComponent").get_faction() == "ally": 
			emit_signal("enqueue_target", area)
	
	if get_parent().get_node("stateComponent").get_faction() == "enemy":
		if area.get_name() == "hitbox" and area.get_parent().get_node("stateComponent").get_faction() == "enemy":
			emit_signal("enqueue_target", area)
