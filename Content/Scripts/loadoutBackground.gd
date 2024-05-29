extends ColorRect

func _can_drop_data(at_position, data):
	return true #데이터가 존재하면 false 출력하도록 변경 

func _on_area_2d_area_entered(area):
	if contains_substring(area.get_parent().get_parent().get_name(), "@Control@"):
		var data = area.get_meta("data")
		print(data)
		var name = area.get_parent().get_parent().get_name()
		emit_signal("inputData",name, data)

func contains_substring(full_string: String, sub_string: String) -> bool:
	return full_string.find(sub_string) != -1
