#이 스크립트는 드래그해서 노드에게 정보를 전달하는 코드만 구현함. 
extends TextureButton

signal inputData(String)

#마우스 트래킹 
var isMouseIn : bool = false

func _get_drag_data(at_position):
	var data : Array
	if self.disabled != true:
		var prev = Control.new()
		var button = NinePatchRect.new()
		button = get_parent().duplicate(4) #Slot node임! 주의! 
		button.position = Vector2.ZERO
		var area = button.get_node("Area2D")
		button.remove_child(area)
		
		data = [
			button.itemName,
			button.itemID
		]
		
		prev.add_child(button)
		set_drag_preview(prev)
	return data

func _can_drop_data(at_position, data):
	return true #데이터가 존재하면 false 출력하도록 변경 
	
func _drop_data(at_position, data):
	#데이터 전달방식 -> drop시 마우스좌표에 data가 저장된 1px by 1px의 collision 생성. 
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(1, 1)
	collision.shape = rect
	
	area.set_meta("data", data)
	
	add_child(area)
	area.add_child(collision)

func _on_area_2d_mouse_entered():
	isMouseIn = true

func _on_area_2d_mouse_exited():
	isMouseIn = false

func _on_area_2d_area_entered(area):
	if isMouseIn:
		var data = area.get_meta("data")
		print(data)
		var name = area.get_parent().get_parent().get_name()
		emit_signal("inputData",name, data)
