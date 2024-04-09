extends Node2D
class_name engageComponent

@export var _status: statusResource
@export var rsc: resourceHandler

#이동속도 상수 설정 
var MOVEMENT_VALUE = 0.0008 # 1/(20*delta) delta = 프레임 수라고 생각하면 됨 (60으로 상정함) 

#stat
@export var unit_tag : String
@export var health : int
@export var speed : float
@export var attack_damage : int
@export var attack_type: bool
@export var ads : float
@export var mana : int

#combat state
@export var state : String
@export var combat_state : String
var isAttack = false
var target = null
var target_queue = Queue.new()

func _ready():
	rsc = get_tree().get_root().get_node("stage1").get_node("resourceHandler")
	
	#resource에서 넘겨받은 것들 집어넣기 
	unit_tag = _status.unit_tag
	health = _status.health
	speed = _status.speed
	attack_damage = _status.a_attack_damage
	attack_type = _status.a_attack_type
	ads = _status.a_ads
	mana = _status.mana
	
	#set state
	state = "move"
	combat_state = "peace"
	
	get_parent().rotates = false
	get_parent().cubic_interp = false
	get_parent().loop = false
	
	#위치 초기화
	if unit_tag == "ally":
		get_parent().progress_ratio = 0.0
	if unit_tag == "enemy":
		get_parent().progress_ratio = 1.0
		
	#collision layer 설정 2 = top / 3 = bottom
	if get_parent().get_parent().get_name() == "topLane":
		#콜리전 마스크 설정 
		get_parent().get_node("hitbox").set_collision_mask_value(1, false)
		get_parent().get_node("hitbox").set_collision_mask_value(2, true)
		get_parent().get_node("attackRangeComponent").set_collision_mask_value(1, false)
		get_parent().get_node("attackRangeComponent").set_collision_mask_value(2, true)
		#콜리전 레이어 설정 
		get_parent().get_node("hitbox").set_collision_layer_value(1, false)
		get_parent().get_node("hitbox").set_collision_layer_value(2, true)
		get_parent().get_node("attackRangeComponent").set_collision_layer_value(1, false)
		get_parent().get_node("attackRangeComponent").set_collision_layer_value(2, true)
	if get_parent().get_parent().get_name() == "bottomLane":
		#콜리전 마스크 설정 
		get_parent().get_node("hitbox").set_collision_mask_value(1, false)
		get_parent().get_node("hitbox").set_collision_mask_value(3, true)
		get_parent().get_node("attackRangeComponent").set_collision_mask_value(1, false)
		get_parent().get_node("attackRangeComponent").set_collision_mask_value(3, true)
		#콜리전 레이어 설정 
		get_parent().get_node("hitbox").set_collision_layer_value(1, false)
		get_parent().get_node("hitbox").set_collision_layer_value(3, true)
		get_parent().get_node("attackRangeComponent").set_collision_layer_value(1, false)
		get_parent().get_node("attackRangeComponent").set_collision_layer_value(3, true)
	
func _physics_process(_delta):
	stateSetter()
	checkHealth()

#캐릭터 상태 설정
func stateSetter(): #state: move, engage
	if state == "move":
		move()
		if target_queue._head != null:
			target = target_queue.dequeue()
			state = "engage"
			combat_state = "cooldown"
	elif state == "engage":
		engage(target)
		if target == null:
			if target_queue._head != null:
				target = target_queue.dequeue()
			else:
				state = "move"
				combat_state = "peace"

func move():
	if unit_tag == "ally":
		get_parent().progress_ratio += MOVEMENT_VALUE * speed
	elif unit_tag == "enemy": 
		get_parent().progress_ratio -= MOVEMENT_VALUE * speed
	get_parent().get_node("AnimationPlayer").play("walk")
	
func engage(target):
	if get_target_state(target) == "dead":
		get_parent().get_node("AnimationPlayer").play("idle")
		await waiting_animation()
	elif combat_state == "cooldown":
		isAttack = false
		get_parent().get_node("AnimationPlayer").play("idle")
		await waiting_animation()
		combat_state = "attack"
	elif combat_state == "attack":
		get_parent().get_node("AnimationPlayer").play("attack")
		await waiting_animation()
		deal_damage(target)
		combat_state = "cooldown"

func get_target_state(target): #target의 state 반환하는 함수
	if (is_instance_valid(target) and (target.get_name() != "allyBase" and target.get_name() != "enemyBase")): 
		return target.get_parent().get_node("engageComponent").state
	else:
		return null

func waiting_animation(): #await 키워드와 함께 사용 
	return get_parent().get_node("AnimationPlayer").animation_finished

func deal_damage(target): #데미지 주기 
	if isAttack == false:
		if is_instance_valid(target): #hitbox 안에 있는지도 검사해야 함 (넉백되었을 때 등)
			if target.get_name() == "hitbox": #유닛 공격 
				target.get_parent().get_node("engageComponent").take_damage(attack_damage)
				print(target.get_parent().get_node("engageComponent").health)
			elif target.get_name() == "allyBase": #아군 베이스 공격 
				get_tree().get_root().get_node("stage1").get_node("resourceHandler").allyBaseDamage(attack_damage)
			elif target.get_name() == "enemyBase": #적군 베이스 공격
				get_tree().get_root().get_node("stage1").get_node("resourceHandler").enemyBaseDamage(attack_damage)
	isAttack = true

func take_damage(damage): #데미지 받기 
	health -= damage

#attackRangeComponent에서 시그널을 받아서 동작
#queue 구현해야 함. target[]에서 enemy 감지시 target에 들어감. target이 빈 리스트가 아니면 engage 
func attack_range_entered(area):
	if unit_tag == "ally":
		if area.get_name() == "hitbox":
			#사거리에 적이 들어오면 target_queue의 끝에 target ID 삽입 
			if area.get_parent().get_node("engageComponent").unit_tag == "enemy":
				target_queue.enqueue(area)
		elif area.get_name() == "enemyBase":
			target_queue.enqueue(area)
		
	elif unit_tag == "enemy":
		if area.get_name() == "hitbox":
			if area.get_parent().get_node("engageComponent").unit_tag == "ally":
				target_queue.enqueue(area)
		elif area.get_name() == "allyBase":
			target_queue.enqueue(area)

func checkHealth():
	if health <= 0:
		state = "dead"
		get_parent().get_node("AnimationPlayer").play("dead")
		await get_parent().get_node("AnimationPlayer").animation_finished
		rsc.decreasePopulation()
		get_parent().queue_free()
