extends Node
class_name StateComponent

#state 관련 인자들 
var current_state : State

var states : Dictionary = {}
@export var initial_state : State

#Unit info
@export var _status: statusResource
@export var rsc : resourceHandler

@export var faction : String
@export var type : String
@export var includedUnit : Array

@export var max_health : int
@export var health : int
@export var speed : float
@export var mana : int

func _enter_tree():
	rsc = get_parent().get_parent().get_parent().get_parent()
	
	#유닛 데이터 입력 
	faction = _status.faction
	type = _status.type
	includedUnit = _status.includedUnit
	
	max_health = _status.health
	health = _status.health
	speed = _status.speed
	mana = _status.mana

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
		#콜리전 레이어 설정 
		if get_parent().has_node("hitbox"):
			get_parent().get_node("hitbox").set_collision_layer_value(1, false)
			get_parent().get_node("hitbox").set_collision_layer_value(2, true)
		if get_parent().has_node("attackRangeComponent"):
			get_parent().get_node("attackRangeComponent").set_collision_layer_value(1, false)
			get_parent().get_node("attackRangeComponent").set_collision_layer_value(2, true)
	elif get_parent().get_parent().get_name() == "bottomLane":
		#콜리전 마스크 설정 
		if get_parent().has_node("hitbox"):
			get_parent().get_node("hitbox").set_collision_mask_value(1, false)
			get_parent().get_node("hitbox").set_collision_mask_value(3, true)
		if get_parent().has_node("attackRangeComponent"):
			get_parent().get_node("attackRangeComponent").set_collision_mask_value(1, false)
			get_parent().get_node("attackRangeComponent").set_collision_mask_value(3, true)
		#콜리전 레이어 설정 
		if get_parent().has_node("hitbox"):
			get_parent().get_node("hitbox").set_collision_layer_value(1, false)
			get_parent().get_node("hitbox").set_collision_layer_value(3, true)
		if get_parent().has_node("attackRangeComponent"):
			get_parent().get_node("attackRangeComponent").set_collision_layer_value(1, false)
			get_parent().get_node("attackRangeComponent").set_collision_layer_value(3, true)
	
	#Shader 불러오기 
	var hit_shader = load("res://Content/Scripts/Shader/hit.tres") as ShaderMaterial
	var outline_shader = load("res://Content/Scripts/Shader/outline.tres") as ShaderMaterial
	
	var currentShader = hit_shader.duplicate() as ShaderMaterial #hit_shader가 기본 쉐이더 
	
	if currentShader:
		$"../Sprite2D".material = currentShader
		
	#미니맵 마커 추가 
	get_parent().get_parent().get_parent().get_parent().get_node("HUD").get_node("minimapUI").spawnMarker(self)
	
	#위치 초기화 및 인구수 추가, 그룹 추가 
	if get_faction() == "enemy": #중간 스폰을 해야할 필요가 있을 때 코드 변경 필요 (스포너에 의해 소환 시 progress_ratio = 1.0으로 설정 
		get_parent().progress_ratio = 1.0
		
		self.add_to_group("enemy")
	else: #중간 스폰을 해야할 필요가 있을 때 코드 변경 필요 (스포너에 의해 소환 시 progress_ratio = 0.0으로 설정 
		rsc.increasePopulation() #인구수 1 증가 
		get_parent().progress_ratio = 0.0
		
		self.add_to_group("ally")
		
	#스프라이트 보정치 추가
	if get_parent().has_node("Sprite2D"):
		var xRand = randi_range(-3,3)
		var yRand = randi_range(0,-10)
		$"../Sprite2D".offset.x += xRand
		$"../Sprite2D".offset.y += yRand
		$"../HealthBarComponent".position.x += xRand
		$"../HealthBarComponent".position.y += yRand
	
func _process(delta):
	#사망 판정 
	if health <= 0:
		force_change_state("Dead")
	else:
		#넉백인지 판정 
		if current_state is KnockBack:
			print("passsss")
			pass
		#캐스트 상태인지 판정 
		elif get_node("Cast").get_target() != null and !(current_state is Cast):
			change_state(current_state, "Cast")
	
	if current_state:
		current_state.Update(delta)
		
func _exit_tree(): #사망 시
	var resultHUD = $"../../../../../ResultHUD"
	if faction == "ally":
		resultHUD.increaseAllyDead()
	elif faction == "enemy":
		resultHUD.increaseEnemyDead()

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

#강제 상태 변경 함수 
func force_change_state(new_state_name : String):
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		print(new_state, " does not exist in the dictionary of states.")
		return
		
	if current_state == new_state:
		#print("State is same.")
		return 
		
	if current_state:
		var exit_callable = Callable(current_state, "Exit")
		exit_callable.call_deferred()
		
	new_state.Enter()
	
	current_state = new_state
#내부 값 변경 함수
func damaged(amount):
	hitShader()
	if faction == "enemy": #데미지를 입는 주체가 적 -> 공격하는 유닛이 아군이므로 공격력 계수 적용해서 데미지 받음 
		health -= int(amount * rsc.get_atk_multiplier()) #공격력 계수 적용 후 정수화 
	else:
		health -= amount
	
func healed(amount):
	if health + amount > max_health: #최대체력 초과시 
		health = max_health
	else:
		health += amount
	
#히트시 쉐이더 작동
func hitShader():
	var material = get_parent().get_node("Sprite2D").material
	if material is ShaderMaterial:
		material.set_shader_parameter("hit_modifier", 1)
		await get_tree().create_timer(0.1).timeout
		material.set_shader_parameter("hit_modifier", 0.3)
		await get_tree().create_timer(0.1).timeout
		material.set_shader_parameter("hit_modifier", 0)

#getter function
func get_type():
	return _status.type

func get_faction():
	return _status.faction
	
func get_includedUnit():
	return _status.includedUnit


func get_max_health():
	return _status.max_health

func get_health():
	return _status.health
	
func get_speed():
	return _status.speed
	
func get_mana():
	return _status.mana
	
	
func on_attackRangeComponent():
	var collision = $"../attackRangeComponent/CollisionShape2D"
	collision.set_deferred("disabled", false)
	
func off_attackRangeComponent():
	var collision = $"../attackRangeComponent/CollisionShape2D"
	collision.set_deferred("disabled", true)
	print("off")
	
#etc function
func property_exists(obj, property_name):
	var properties = obj.get_property_list()
	for property in properties:
		if property.name == property_name:
			return true
	return false
