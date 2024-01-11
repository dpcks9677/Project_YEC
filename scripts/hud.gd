extends CanvasLayer


@export var slot_1 : PackedScene
@export var slot_2 : PackedScene
@export var slot_3 : PackedScene
@export var slot_4 : PackedScene
@export var slot_5 : PackedScene
@export var slot_6 : PackedScene
@export var slot_7 : PackedScene
@export var slot_8 : PackedScene

func _ready():
	slot_1 = preload("res://units/ally/spearman.tscn")
	slot_2 = preload("res://units/ally/knight.tscn")

func _process(delta):
	pass

func spawn(unit):
	#인스턴스화
	var target = unit.instantiate()
	
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
