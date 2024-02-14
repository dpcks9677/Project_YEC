extends Area2D
class_name base

#stat
@export var unit_tag : String
@export var state : String

func _ready():
	#state 설정
	state = "hold"
	
	#베이스 팀 설정 
	if name == "allyBase":
		unit_tag = "ally"
	else:
		unit_tag = "enemy"
		
