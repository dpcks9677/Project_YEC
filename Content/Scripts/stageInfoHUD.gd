extends CanvasLayer

var infoFile = {}

@onready var infoFilePath = "res://Content/Scripts/stageInfo.json"

func _ready():
	infoFile = load_json_file(infoFilePath) #파싱, Dictionary 형식으로 저장됨 
	print(infoFile["stage1"])	
	
#파싱 함수 
func load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error reading file")
	else:
		print("file doesn't exist")

func _on_stage_1_pressed():
	var data = infoFile["stage1"] #dictionary
	
	$Sprite2D/stageNumber.text = "Stage 1" #스테이지 넘버링 
	$Sprite2D/stageName.text = data["stageName"] #스테이지 이름 
	
	for i in range(2):
		var unitArr = data["enemyUnits"]
		var img = load("res://Content/Graphics/Sprites/portrait/" + str(unitArr[i]) + ".png")
		
		var unitSlotStr = "unitSlot" + str(i+1)
		print(unitSlotStr)
		get_node("Sprite2D/unitInfo").get_node(unitSlotStr).get_node("Sprite2D").texture = img
	

func _on_stage_2_pressed():
	var data = infoFile["stage2"] #dictionary
	
	$Sprite2D/stageNumber.text = "Stage 2" #스테이지 넘버링 
	$Sprite2D/stageName.text = data["stageName"] #스테이지 이름 
	
	for i in range(2):
		var unitArr = data["enemyUnits"]
		var img = load("res://Content/Graphics/Sprites/portrait/" + str(unitArr[i]) + ".png")
		
		var unitSlotStr = "unitSlot" + str(i+1)
		print(unitSlotStr)
		get_node("Sprite2D/unitInfo").get_node(unitSlotStr).get_node("Sprite2D").texture = img


func _on_stage_3_pressed():
	var data = infoFile["stage3"] #dictionary
	
	$Sprite2D/stageNumber.text = "Stage 3" #스테이지 넘버링 
	$Sprite2D/stageName.text = data["stageName"] #스테이지 이름 


func _on_enter_pressed():
	visible = false
	get_parent().get_node("loadoutHUD").visible = true
