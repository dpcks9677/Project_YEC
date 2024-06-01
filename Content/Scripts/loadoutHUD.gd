extends CanvasLayer

func checkItemEquippedNull():
	for i in range(20):
		if SaveData.getOwnedUnitListSlot(i) != 0:
			return false
	return true

#signal
func _on_enter_button_pressed():
	if checkItemEquippedNull(): #itemEquipped가 비었는지 체크
		print("You must equip at least one item.")
	else:
		print("ya")
		var stageName = get_parent().getStageScene()
		var stageScene = load("res://Content/Scenes/Stage/" + stageName + ".tscn")
		#화면 전환 씬 재생 필요 
		get_tree().change_scene_to_packed(stageScene)
	
func _on_back_button_pressed():
	get_parent().get_node("stageInfoHUD").visible  = true
	self.visible = false

