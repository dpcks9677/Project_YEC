extends Control

const savePath = "user://Saves/"
const saveFile = "save1.json"
const SECURITY_KEY = "intheafterglow"

var savedata = saveData.new()

func _ready():
	verify_save_directory(savePath)

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)
	
func save_data(path : String):
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
		if data == null:
			printerr("Cannot parse %s as a json string: (%s)!" %[path, content])
			return
		
		savedata = saveData.new()
		savedata.gold = data.save_data.gold
		savedata.currentStage = data.save_data.currentStage
		savedata.playTime = data.save_data.playTime
		
		
	else:
		printerr("Cannot open non-existent file at %s!" %[path])

#Signals
func _on_quit_button_pressed():
	get_tree().quit()

func _on_continue_button_pressed():
	get_node("LoadScene").visible = true

func _on_back_button_pressed():
	get_node("LoadScene").visible = false

func _on_button_1_pressed():
	load_data(savePath+saveFile)
	get_node("LoadScene").get_node("saveInfo").text = str(savedata.gold)

func _on_new_game_button_pressed():
	save_data(savePath+saveFile)
