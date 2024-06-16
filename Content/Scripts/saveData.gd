extends Node
class_name saveData

#데이터 저장을 위한 변수 
var saveIdx : int = 0

const savePath = "res://Saves/"

@export var gold : int
@export var currentStage : int
@export var playTime : int

#null String, 기본 페이지 수에 따라 확장 
@export var ownedUnitList : Array = [
	#name, id(0 = null), isEquipped(idx, 0 = null)
	["", 0, 0],  
	["", 0, 0], 
	["", 0, 0], 
	["", 0, 0],
	["", 0, 0],  
	["", 0, 0], 
	["", 0, 0], 
	["", 0, 0], 
	["", 0, 0],  
	["", 0, 0], 
	["", 0, 0], 
	["", 0, 0],   
	["", 0, 0],  
	["", 0, 0], 
	["", 0, 0], 
	["", 0, 0], 
	["", 0, 0],  
	["", 0, 0], 
	["", 0, 0], 
	["", 0, 0]  
]

@export var ownedTowerList : Array = [
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null]
]

#function 
func save_data(path : String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print(FileAccess.get_open_error())
		return
		
	var data = {
		"save_data": {
			"gold" : gold,
			"currentStage" : currentStage,
			"playTime" : playTime,
			
			"ownedUnitList" : ownedUnitList,
			"ownedTowerList" : ownedTowerList
		}
	}
	
	var json_data = JSON.new().stringify(data)
	json_data = JSONBeautifier.beautify_json(json_data)
	file.store_string(json_data)
	file.close()
	file = null


#getter
func getOwnedUnitListName(idx):
	return ownedUnitList[idx][0]

func getOwnedUnitListID(idx):
	return ownedUnitList[idx][1]

func getOwnedUnitListSlot(idx):
	return ownedUnitList[idx][2]

#setter
func setOwnedUnitListName(idx,value):
	ownedUnitList[idx][0] = value
	save_data("res://Saves/save" + str(saveIdx) + ".json")

func setOwnedUnitListID(idx, value):
	ownedUnitList[idx][1] = value
	save_data("res://Saves/save" + str(saveIdx) + ".json")

func setOwnedUnitListSlot(idx, value):
	ownedUnitList[idx][2] = value
	save_data("res://Saves/save" + str(saveIdx) + ".json")
