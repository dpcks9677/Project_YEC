extends TextureButton

#마우스 트래킹 
var isMouseIn : bool = false

func _get_drag_data(at_position):
	var prev = Control.new()
	var button = NinePatchRect.new()
	button = get_parent().duplicate(15) #Slot node임! 주의! 
	button.position = Vector2.ZERO
	var area = button.get_node("Area2D")
	button.remove_child(area)

	prev.add_child(button)
	set_drag_preview(prev)
	
	var spriteData = button.get_node("TextureButton").get_node("Sprite2D").texture
	var manaData = button.get_node("TextureButton/manaTag/mana").text
	var itemData = button.itemName
	
	var data = [
		spriteData,
		manaData,
		itemData
	]
	
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
	
	#메타데이터 추가 
	area.set_meta("data", data)
	print(area.get_meta("data"))
	
	add_child(area)
	area.add_child(collision)

func _on_area_2d_mouse_entered():
	isMouseIn = true

func _on_area_2d_mouse_exited():
	isMouseIn = false

func _on_area_2d_area_entered(area):
	if isMouseIn:
		var data = area.get_meta("data")
		
		#$Sprite2D.texture = data[0]
		get_parent().itemName = data[2]
		$manaTag/mana.text = data[1]
