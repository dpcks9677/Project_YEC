extends PathFollow2D

var unitInfo
var unit_tag

func _ready():
	#유닛 태그 설정 
	unit_tag = unitInfo.get_node("stateComponent").unit_tag
	
	#마커 색상 부여 후 위치 초기화 
	if unit_tag == "ally":
		get_node("Polygon2D").set_color(Color(0,1,0,0.8))
		set_progress_ratio(0.0) #아군은 왼쪽부터 
	elif unit_tag == "enemy":
		get_node("Polygon2D").set_color(Color(1,0,0,0.8))
		set_progress_ratio(1.0) #적군은 오른쪽부터

func _physics_process(_delta):
	if is_instance_valid(unitInfo):
		setProgression(unitInfo)

func setTarget(target):
	unitInfo = target

func setProgression(target):
	set_progress_ratio(target.progress_ratio)
