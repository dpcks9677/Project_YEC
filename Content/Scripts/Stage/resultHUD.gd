extends CanvasLayer

var resultSlot : PackedScene
var infoFile = {}
@onready var infoFilePath = "res://Content/Scripts/stageInfo.json"

func _enter_tree():
	resultSlot = load("res://Content/Scenes/Stage/Interfaces/resultSlot.tscn")

func _ready():
	#signal 연결 
	#$"../resourceHandler/laneSetter/allyBase".stageEnd.connect(_on_stage_end)
	#$"../resourceHandler/laneSetter/enemyBase".stageEnd.connect(_on_stage_end)
	
	infoFile = load_json_file(infoFilePath) #파싱, Dictionary 형식으로 저장됨 
	var clearReward = infoFile["stage1"]["clearReward"]
	print(clearReward) #보상 유닛리스트 출력
	
	for i in clearReward:
		var addResultSlot = resultSlot.instantiate()
		var itemInfo = load("res://Content/Scripts/Resources/unitData/" + i +".tres")
		addResultSlot.custom_minimum_size.x = 117
		addResultSlot.custom_minimum_size.y = 75
		addResultSlot.itemName = i
		addResultSlot.get_node("TextureButton/manaTag/mana").text = str(itemInfo.mana)
		print(addResultSlot.itemName)
		$Wrapper/VBoxContainer/rewardBox.add_child(addResultSlot)
		
	slide_tween_in()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

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

#setter
func set_playtime(time : float): #resourceHandler가 실행 
	$Wrapper/VBoxContainer/playtimeResult.text = str(int(time)/60) + ":" + str(int(time)%60)

#tween func
func slide_tween_in():
	var tween = create_tween()
	tween.tween_property($Wrapper, "position", Vector2(0, 0), 0.6).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)

#signal
func _on_stage_end(isWin): #스테이지 종료시 할 작업들 모두 추가
	self.visible = true
	
	if isWin:
		$Wrapper/resultLabel.text = "승리!!!"
	else:
		$Wrapper/resultLabel.text = "패배..."

func _on_button_pressed(): #스테이지에서 map 씬으로 넘어가야 함 
	pass # Replace with function body.
