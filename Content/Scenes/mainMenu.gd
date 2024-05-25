extends Control

const savePath = "res://Saves/"
const saveFile = "save1.json"

#Scene preload
const map = preload("res://Content/Scenes/map.tscn")

var currentSave = null

var savedata = saveData.new() #불러온 데이터가 저장되는 변수. 이 변수를 호출해서 데이터를 불러오면 됨.

func _ready():
	get_node("transition/ColorRect").visible = false
	get_node("LoadScene").visible = false
	verify_save_directory(savePath)

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)
	
func save_data(path : String): #메인메뉴에서 사용하지 않는 기능. 씬 작업 후 옮기기 바람.
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print(FileAccess.get_open_error())
		return
		
	var data = {
		"save_data": {
			"gold" : savedata.gold,
			"currentStage" : savedata.currentStage,
			"playTime" : savedata.playTime
		}
	}

	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

func load_data(path : String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file == null:
			print(FileAccess.get_open_error())
			return
		
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		print(data)
		if data == null:
			printerr("Cannot parse %s as a json string: (%s)!" %[path, content])
			return
		
		SaveData.gold = data.save_data.gold
		SaveData.currentStage = data.save_data.currentStage
		SaveData.playTime = data.save_data.playTime
		
		SaveData.ownedUnitList = data.save_data.ownedUnitList
		
	else:
		printerr("Cannot open non-existent file at %s!" %[path])

func transfer_data_between_scenes(old_scene, new_scene):
	new_scene.savedata = old_scene.savedata #new_scene이 packedScene임 

#Signals
func _on_quit_button_pressed():
	get_tree().quit()

func _on_continue_button_pressed():
	get_node("LoadScene").visible = true

func _on_back_button_pressed():
	get_node("LoadScene").visible = false

func _on_button_1_pressed():
	currentSave = 1
	load_data(savePath+saveFile)
	get_node("LoadScene").get_node("saveInfo").text = str("gold : " , SaveData.gold, " / ", "stage : ", SaveData.currentStage)

func _on_new_game_button_pressed():
	save_data(savePath+saveFile)

func _on_next_button_pressed():
	if currentSave != 0:
		#transfer_data_between_scenes(self, map)
		get_node("transition").play("fade_out")


func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_packed(map)
