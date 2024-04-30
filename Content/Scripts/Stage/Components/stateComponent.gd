extends Node
class_name StateComponent

#state 관련 인자들 
var current_state : State

var states : Dictionary = {}
@export var initial_state : State

#Unit info
@export var _status: statusResource

@export var unit_tag : String
@export var health : int
@export var speed : float
@export var mana : int
@export var attack_damage : int

func _enter_tree():
	#유닛 데이터 입력 
	unit_tag = _status.unit_tag
	health = _status.health
	speed = _status.speed
	mana = _status.mana
	attack_damage = _status.a_attack_damage

func _ready():
	#설정한 상태로 초기화 (노드 이용) 
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

	if get_parent().get_parent().get_name() == "topLane":
		#콜리전 마스크 설정 
		if get_parent().has_node("hitbox"):
			get_parent().get_node("hitbox").set_collision_mask_value(1, false)
			get_parent().get_node("hitbox").set_collision_mask_value(2, true)
		if get_parent().has_node("attackRangeComponent"):
			get_parent().get_node("attackRangeComponent").set_collision_mask_value(1, false)
			get_parent().get_node("attackRangeComponent").set_collision_mask_value(2, true)
		if get_parent().has_node("damageBox"):
			get_parent().get_node("damageBox").set_collision_mask_value(1, false)
			get_parent().get_node("damageBox").set_collision_mask_value(2, true)
		#콜리전 레이어 설정 
		if get_parent().has_node("hitbox"):
			get_parent().get_node("hitbox").set_collision_layer_value(1, false)
			get_parent().get_node("hitbox").set_collision_layer_value(2, true)
		if get_parent().has_node("attackRangeComponent"):
			get_parent().get_node("attackRangeComponent").set_collision_layer_value(1, false)
			get_parent().get_node("attackRangeComponent").set_collision_layer_value(2, true)
		if get_parent().has_node("damageBox"):
			get_parent().get_node("damageBox").set_collision_mask_value(1, false)
			get_parent().get_node("damageBox").set_collision_mask_value(2, true)
	if get_parent().get_parent().get_name() == "bottomLane":
		#콜리전 마스크 설정 
		if get_parent().has_node("hitbox"):
			get_parent().get_node("hitbox").set_collision_mask_value(1, false)
			get_parent().get_node("hitbox").set_collision_mask_value(3, true)
		if get_parent().has_node("attackRangeComponent"):
			get_parent().get_node("attackRangeComponent").set_collision_mask_value(1, false)
			get_parent().get_node("attackRangeComponent").set_collision_mask_value(3, true)
		if get_parent().has_node("damageBox"):
			get_parent().get_node("damageBox").set_collision_mask_value(1, false)
			get_parent().get_node("damageBox").set_collision_mask_value(3, true)
		#콜리전 레이어 설정 
		if get_parent().has_node("hitbox"):
			get_parent().get_node("hitbox").set_collision_layer_value(1, false)
			get_parent().get_node("hitbox").set_collision_layer_value(3, true)
		if get_parent().has_node("attackRangeComponent"):
			get_parent().get_node("attackRangeComponent").set_collision_layer_value(1, false)
			get_parent().get_node("attackRangeComponent").set_collision_layer_value(3, true)
		if get_parent().has_node("damageBox"):
			get_parent().get_node("damageBox").set_collision_mask_value(1, false)
			get_parent().get_node("damageBox").set_collision_mask_value(3, true)

			
func _process(delta):
	if current_state:
		current_state.Update(delta)
		
#상태 변경 함수 
func change_state(state : State, new_state_name : String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state

#내부 값 변경 함수
func damaged(amount):
	health -= amount

#getter function
func get_Unit_tag():
	return unit_tag
	
func get_speed():
	return speed
