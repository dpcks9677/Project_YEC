extends Node

#상태이상 정의 
@export var isStun : bool = false
@export var isSlow : bool = false
@export var isBurn : bool = false
	
func setStun():
	isStun = true
	
func setSlow():
	isSlow = true
	
func setBurn():
	isBurn = true
