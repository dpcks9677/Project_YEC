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
	attack_damage = _status.attack_damage
	attack_type = _status.attack_type
	ads = _status.ads
	mana = _status.mana
	
	#set state
	state = "move"
	combat_state = "peace"
	
	get_parent().rotates = false
	get_parent().cubic_interp = false
	get_parent().loop = false
	
	#시작 좌표 설정 / topLane, bottomLane에 배치하는 로직도 짜야 함 
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
				#target 관련 코드
				
#자동이동 및 걷기 애니메이션 
func move():
	if unit_tag == "ally":
		get_parent().progress_ratio += MOVEMENT_VALUE * speed
	elif unit_tag == "enemy": 
		get_parent().progress_ratio -= MOVEMENT_VALUE * speed
	get_parent().get_node("AnimationPlayer").play("walk")
	
func engage(target):
	if combat_state == "cooldown":
		isAttack = false
		get_parent().get_node("AnimationPlayer").play("idle")
		await waiting_animation()
		combat_state = "attack"
	elif combat_state == "attack":
		get_parent().get_node("AnimationPlayer").play("attack")
		await waiting_animation()
		damage(target)
		combat_state = "cooldown"

func waiting_animation(): #await 키워드와 함께 사용 
	return get_parent().get_node("AnimationPlayer").animation_finished

func damage(target):
	if isAttack == false:
		if is_instance_valid(target):
			if target.get_name() == "hitbox": #유닛 공격 
				target.get_parent().get_node("engageComponent").health -= attack_damage #연산 
				print(target.get_parent().get_node("engageComponent").health)
			elif target.get_name() == "allyBase": #아군 베이스 공격 
				get_tree().get_root().get_node("stage1").get_node("resourceHandler").allyBaseHealth -= attack_damage
			elif target.get_name() == "enemyBase": #적군 베이스 공격
				get_tree().get_root().get_node("stage1").get_node("resourceHandler").enemyBaseHealth -= attack_damage
	isAttack = true

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

#attackRangeComponent에서 시그널을 받아서 동작
func attack_range_exited(area):
	if unit_tag == "ally":
		if area.get_name() == "hitbox":
			#사거리에 적이 들어오면 target_queue의 끝에 target ID 삽입 
			if area.get_parent().get_node("engageComponent").unit_tag == "enemy":
				pass
		
	elif unit_tag == "enemy":
		if area.get_name() == "hitbox":
			if area.get_parent().get_node("engageComponent").unit_tag == "ally":
				pass

func checkHealth():
	if health <= 0:
		get_parent().get_node("AnimationPlayer").play("idle")
		get_parent().get_node("AnimationPlayer").pause()
		rsc.population -= 1
		get_parent().queue_free()
