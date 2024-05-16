extends Control

#marker 씬 로드 
var marker = load("res://Content/Scenes/Stage/Interfaces/marker.tscn")

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func spawnMarker(target): #faction 식별, 마커 스폰 라인 설정, progress 구하기 target = stateComponent
	var faction : String
	var location : bool # false = top, true = bottom
	
	var markerInstant = marker.instantiate()
	
	markerInstant.setTarget(target)
	
	#faction 식별 
	faction = target.get_faction()
	
	#라인에 따라 객체 생성하기 
	if target.get_parent().get_parent().get_name() == "topLane":
		get_node("topLane").add_child(markerInstant)
	elif target.get_parent().get_parent().get_name() == "bottomLane":
		get_node("bottomLane").add_child(markerInstant)
		print("executed")
