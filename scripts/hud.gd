extends CanvasLayer

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
	displayMana()

#unitSommoner 관련 스크립트  
func spawn(unit):
	#인스턴스화 먼저 (정보 얻어와야 함) 
	var target = unit.instantiate()
	
	#마나 여부 확인
	#이유를 모르겠으나 mana를 조회하면 계속 0으로 나와서 _status.mana로 접근해야 원하는 대로 동작함.
	if target.get_node("engageComponent")._status.mana > rsc.current_mana: 
		print("no mana")
	else:
		print(target.get_node("engageComponent").mana)
		#마나 지불 
		rsc.current_mana -= target.get_node("engageComponent")._status.mana
		
		#좌표 설정
		target.position.x = 0
		target.position.y = 360
		
		#stage1 씬에 노드 추가 
		get_tree().get_root().get_node("stage1").add_child(target)
		print("spawned")

func _on_slot_1_button_up():
	spawn(slot_1)

func _on_slot_2_button_up():
	spawn(slot_2)

#manaUI 관련 스크립트 
func displayMana():
	get_node("manaUI").get_node("manaLabel").text = str("your mana: ", rsc.current_mana)
