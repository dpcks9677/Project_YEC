extends Node
class_name saveData

@export var gold : int
@export var currentStage : int
@export var playTime : int

#null String, 기본 페이지 수에 따라 확장 
@export var ownedUnitList : Array = [
	#name, id(0 = null), isEquipped(idx, 0 = null)
	["spearman", 1, 1],
	["knight", 1, 2] ,
	["hero", 1, 3], 
	["spearman", 2, 0], 
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

@export var equippedList : Array = [
	["hero", 1],
	["spearman", 1],
	["knight", 1] ,
	["", 0], 
	["", 0],  
	["", 0], 
	["", 0], 
	["", 0],  
]

func getEquippedListItemName(idx : int):
	return equippedList[idx][0]
