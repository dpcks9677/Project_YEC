extends Control

#marker 씬 로드 
var marker = load("res://Content/Scenes/Stage/Interfaces/marker.tscn")

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func spawnMarker(target): #unit_tag 식별, 마커 스폰 라인 설정, progress 구하기 
	var unit_tag : String
	var location : bool # false = top, true = bottom
	
	var markerInstant = marker.instantiate()
	
	#unit_tag 식별 
	unit_tag = target.get_node("engageComponent").unit_tag
	
	#마커 색상 부여 후 위치 초기화 
	if unit_tag == "ally":
		markerInstant.get_node("Polygon2D").set_color(Color(0,1,0,0.8))
		#markerInstant.get_node("Polygon2D").set_progress_ratio(0.0) #아군은 왼쪽부터 
	elif unit_tag == "enemy":
		markerInstant.get_node("Polygon2D").set_color(Color(1,0,0,0.8))
		#markerInstant.get_node("Polygon2D").set_progress_ratio(1.0) #적군은 오른쪽부터
	
	#라인에 따라 객체 생성하기 
	if target.get_parent().get_name() == "topLane":
		get_node("topLane").add_child(markerInstant)
	elif target.get_parent().get_name() == "bottomLane":
		get_node("bottomLane").add_child(markerInstant)
		
