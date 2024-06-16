extends Control

const savePath = "res://Saves/"
var saveFile : String

#Scene preload
const map = preload("res://Content/Scenes/map.tscn")

#현재 탭
@export var currentTap : int = 0 # 0 : 바탕화면 / 1 : New Game / 2 : Load Games

#세이브파일 
@export var currentSaveFile : int = 0
var currentSaveFileExist : bool = 0

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
			"playTime" : savedata.playTime,
			
			"ownedUnitList" : savedata.ownedUnitList,
			"ownedTowerList" : savedata.ownedTowerList
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
		
		SaveData.saveIdx = currentSaveFile
		
		SaveData.gold = data.save_data.gold
		SaveData.currentStage = data.save_data.currentStage
		SaveData.playTime = data.save_data.playTime
		SaveData.ownedUnitList = data.save_data.ownedUnitList
		SaveData.ownedTowerList = data.save_data.ownedTowerList
		
	else:
		printerr("Cannot open non-existent file at %s!" %[path])

func transfer_data_between_scenes(old_scene, new_scene):
	new_scene.savedata = old_scene.savedata #new_scene이 packedScene임 

#Signals
func _on_quit_button_pressed():
	get_tree().quit()

func _on_continue_button_pressed():
	currentTap = 2
	$LoadScene.visible = true
	$newGameScene.visible = false

func _on_back_button_pressed():
	currentTap = 0
	$LoadScene.visible = false
	$newGameScene.visible = false

func _on_new_game_button_pressed():
	currentTap = 1
	$newGameScene.visible = true
	$LoadScene.visible = false

func _on_next_button_pressed():
	if currentSaveFile != 0: #현재 클릭한 세이브 파일 
		if currentTap == 1 and currentSaveFileExist == false: #New Game 탭이고, 클릭한 세이브 파일이 비어있음 
			var defaultFile = FileAccess.open("res://Saves/default_save.json", FileAccess.READ) #기본 세이브파일 불러오기 
			var file = FileAccess.open(savePath + "save" + str(currentSaveFile) + ".json", 7) # ModeFlags WRITE_READ == 7 
			file.store_buffer(defaultFile.get_buffer(defaultFile.get_length())) 
			
			defaultFile.close() 
			file.close() 
		elif currentTap == 1 and currentSaveFileExist == true:
			print("save file is exist")
			return 0
			
		elif currentTap == 2 and currentSaveFileExist == false:
			print("file is empty!")
			return 0
			
		load_data(savePath + "save" + str(currentSaveFile) + ".json")
		get_node("transition").play("fade_out")

func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_packed(map)

func _on_button_1_pressed():
	currentSaveFile = 1
	displayFileInfo(savePath + "save1.json")

func _on_button_2_pressed():
	currentSaveFile = 2
	displayFileInfo(savePath + "save2.json")

func _on_button_3_pressed():
	currentSaveFile = 3
	displayFileInfo(savePath + "save3.json")
	
func displayFileInfo(path : String):
	if FileAccess.file_exists(path):
		currentSaveFileExist = true
		load_data(path)
		$LoadScene/saveInfo.text = str("gold : " , SaveData.gold, " / ", "stage : ", SaveData.currentStage)
		$newGameScene/saveInfo.text = str("gold : " , SaveData.gold, " / ", "stage : ", SaveData.currentStage)
	else:
		currentSaveFileExist = false
		$LoadScene/saveInfo.text = "empty"
		$newGameScene/saveInfo.text = "empty"
