extends Node
class_name saveData

@export var gold : int
@export var currentStage : int
@export var playTime : int

#null String, 기본 페이지 수에 따라 확장 
@export var ownedUnitList : Array = [
	"spearman", "knight", "", "", "", "", "", "", "", "",
	"", "", "", "", "", "", "", "", "", ""
]

@export var ownedTowerList : Array = [
	"", "", "", "", "", "", "", "", "", ""
]

@export var equippedList : Array = [
	"hero", 
	"spearman", 
	"", 
	"", 
	"", 
	"", 
	"", 
	""
]

