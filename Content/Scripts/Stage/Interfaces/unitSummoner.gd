extends Control

signal unitSpawn

#유닛 이름, 씬 저장 할 배열 선언 
@export var unitName := [null, null, null, null, null, null, null, null]
@export var unitScene := [null, null, null, null, null, null, null, null]

var slotSide : bool

#resourceHandler 형식 선언
@export var rsc : resourceHandler

func _init():
	#SaveData를 참조해서 데이터 삽입 
	for i in range(8):
		for j in range(20):
			if SaveData.getOwnedUnitListSlot(j) == i+1:
				unitName[i] = SaveData.getOwnedUnitListName(j)
	
	slotSide = false

func _ready():
	rsc = get_parent().get_parent()
	
	#씬 불러 올 때, 직접 경로를 적지 않고, 데이터를 인계받아서 자리에 맞게 유닛을 매치 할 수 있도록 설계 
	for i in range(8):
		if unitName[i] != null:
			var unitData = load("res://Content/Scenes/Units/ally/" + unitName[i] + ".tscn")
			unitScene[i] = unitData
		
func _process(_delta):
	pass

func spawn(unit):
	#인스턴스화 먼저 (정보 얻어와야 함) 
	var target
	var idx : int
	
	for i in range(8):
		if str(unitName[i]) == str(unit):
			idx = i

	target = unitScene[idx].instantiate()
	
	if target.get_class() == "Node2D": #여러 유닛을 소환하는 코드 
		if rsc.get_population() + len(target.get_node("stateComponent").get_includedUnit()) > rsc.get_max_population(): #인구 수 확인 
			print("Population limit exceeded.")
		else: #마나 여부 확인 / 이유를 모르겠으나 mana를 조회하면 계속 0으로 나와서 _status.mana로 접근해야 원하는 대로 동작함.
			if target.get_node("stateComponent").get_mana() > rsc.get_current_mana(): 
				print("no mana")
			else:
				print(target.get_node("stateComponent").get_mana())
				#마나 지불 
				rsc.set_current_mana(rsc.get_current_mana() - target.get_node("stateComponent").get_mana())
				
				#stage1 씬에 노드 추가 false = top / true = bottom 
				if get_parent().get_node("laneUI").currentLane == true:
					for i in len(target.get_node("stateComponent").get_includedUnit()):
						var spawnUnit = load("res://Content/Scenes/Units/ally/" + str(target.get_node("stateComponent").get_includedUnit()[i]) + ".tscn").instantiate()
						get_parent().get_parent().get_node("laneSetter").get_node("bottomLane").add_child(spawnUnit)
				else:
					for i in len(target.get_node("stateComponent").get_includedUnit()):
						var spawnUnit = load("res://Content/Scenes/Units/ally/" + str(target.get_node("stateComponent").get_includedUnit()[i]) + ".tscn").instantiate()
						get_parent().get_parent().get_node("laneSetter").get_node("topLane").add_child(spawnUnit)
	else: #단일 유닛을 소환하는 코드 
		if rsc.get_population() >= rsc.get_max_population(): #인구 수 확인 
			print("Population limit exceeded.")
		else: #마나 여부 확인 
			if target.get_node("stateComponent").get_mana() > rsc.get_current_mana(): 
				print("no mana")
			else:
				#마나 지불 
				rsc.set_current_mana(rsc.get_current_mana() - target.get_node("stateComponent").get_mana())
				
				#stage1 씬에 노드 추가 false = top / true = bottom 
				if get_parent().get_node("laneUI").currentLane == true:
					get_parent().get_parent().get_node("laneSetter").get_node("bottomLane").add_child(target)
					print("bottom spawned")
				else:
					get_parent().get_parent().get_node("laneSetter").get_node("topLane").add_child(target)
					print("top spawned")

func _on_slot_changer_toggled(toggled_on):
	if slotSide == false:
		get_node("unitButton1").visible = false
		get_node("unitButton2").visible = false
		get_node("unitButton3").visible = false
		get_node("unitButton4").visible = false
		
		get_node("unitButton5").visible = true
		get_node("unitButton6").visible = true
		get_node("unitButton7").visible = true
		get_node("unitButton8").visible = true
		
		slotSide = true
	else:
		get_node("unitButton1").visible = true
		get_node("unitButton2").visible = true
		get_node("unitButton3").visible = true
		get_node("unitButton4").visible = true
		
		get_node("unitButton5").visible = false
		get_node("unitButton6").visible = false
		get_node("unitButton7").visible = false
		get_node("unitButton8").visible = false
		
		slotSide = false
