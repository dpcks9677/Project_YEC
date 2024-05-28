extends Node
class_name saveData

@export var gold : int
@export var currentStage : int
@export var playTime : int

#null String, 기본 페이지 수에 따라 확장 
@export var ownedUnitList : Array = [
	#name, id
	["spearman", 0],
	["knight", 0] ,
	["hero", 0], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
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
	["hero", 0],
	["spearman", 0],
	["knight", 0] ,
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null], 
	["", null]
]

