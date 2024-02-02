extends Control

#유닛 이름, 씬 저장 할 배열 선언 
@export var unitName := [null, null, null, null, null, null, null, null]
@export var unitScene := [null, null, null, null, null, null, null, null]

#resourceHandler 형식 선언
@export var rsc : resourceHandler

func _init():
	#스테이지 진입 전 준비 씬에서 정보를 넘겨받아서 작성해야 함.
	unitName[0] = "spearman" 
	unitName[1] = "knight"
	unitName[2] = "archer"


func _ready():
	rsc = get_tree().get_root().get_node("stage1").get_node("resourceHandler")
	
	#씬 불러 올 때, 직접 경로를 적지 않고, 데이터를 인계받아서 자리에 맞게 유닛을 매치 할 수 있도록 설계 
	for i in range(8) :
		unitScene[i] = load("res://units/ally/" + str(unitName[i]) + ".tscn")
		
func _process(delta):
	pass

func spawn(unit):
	#인스턴스화 먼저 (정보 얻어와야 함) 
	var target
	var idx
	
	for i in range(8):
		if str(unitName[i]) == str(unit):
			idx = i

	target = unitScene[idx].instantiate()
	
	if rsc.isPopulationFull == true: #인구 수 확인 
		print("no space")
	else: #마나 여부 확인 / 이유를 모르겠으나 mana를 조회하면 계속 0으로 나와서 _status.mana로 접근해야 원하는 대로 동작함.
		if target.get_node("engageComponent")._status.mana > rsc.current_mana: 
			print("no mana")
		else:
			print(target.get_node("engageComponent").mana)
			#마나 지불 
			rsc.current_mana -= target.get_node("engageComponent")._status.mana
			
			#stage1 씬에 노드 추가 false = top / true = bottom 
			if get_parent().get_node("laneUI").currentLane == true:
				get_tree().get_root().get_node("stage1").get_node("laneSetter").get_node("bottomLane").add_child(target)
				print("top spawned")
			else:
				get_tree().get_root().get_node("stage1").get_node("laneSetter").get_node("topLane").add_child(target)
				print("bottom spawned")
			
			#인구수 1 증가 
			rsc.population += 1
