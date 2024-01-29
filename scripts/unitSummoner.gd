extends Control

#유닛 씬 형식 선언 
@export var slot_1 : PackedScene
@export var slot_2 : PackedScene
@export var slot_3 : PackedScene
@export var slot_4 : PackedScene
@export var slot_5 : PackedScene
@export var slot_6 : PackedScene
@export var slot_7 : PackedScene
@export var slot_8 : PackedScene

#resourceHandler 형식 선언
@export var rsc : resourceHandler

func _ready():
	#slot 불러 올 때, 직접 경로를 적지 않고, 데이터를 인계받아서 자리에 맞게 유닛을 매치 할 수 있도록 설계 
	slot_1 = preload("res://units/ally/spearman.tscn")
	slot_2 = preload("res://units/ally/knight.tscn")
	
	rsc = get_tree().get_root().get_node("stage1").get_node("resourceHandler")

func _process(delta):
	pass

func spawn(unit):
	#인스턴스화 먼저 (정보 얻어와야 함) 
	var target = unit.instantiate()
	
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

func _on_slot_1_button_up():
	spawn(slot_1)

func _on_slot_2_button_up():
	spawn(slot_2)

