extends PathFollow2D

var unitInfo
var faction

func _ready():
	#유닛 팩션 설정 
	faction = unitInfo.get_node("stateComponent").get_faction()
	
	#마커 색상 부여 후 위치 초기화 
	if faction == "ally":
		get_node("Polygon2D").set_color(Color(0,1,0,0.8))
		set_progress_ratio(0.0) #아군은 왼쪽부터 
	elif faction == "enemy":
		get_node("Polygon2D").set_color(Color(1,0,0,0.8))
		set_progress_ratio(1.0) #적군은 오른쪽부터

func _physics_process(_delta):
	if is_instance_valid(unitInfo):
		setProgression(unitInfo)
	else:
		queue_free()

func setTarget(target): #target = stateComponent 
	unitInfo = target.get_parent() # => pathfollow2D

func setProgression(target):
	set_progress_ratio(target.progress_ratio)
