extends Node2D
class_name engageComponent

@export var _status: statusResource

#이동속도 상수 설정 
var MOVEMENT_VALUE = 0.0008 # 1/(20*delta) delta = 프레임 수라고 생각하면 됨 (60으로 상정함) 

#stat
@export var unit_tag : String
@export var health : int
@export var speed : float
@export var attack_damage : int
@export var attack_type: bool
@export var ads: float
@export var mana : int

#combat state
@export var state = "move"
@export var combat_state = "peace"
var isAttackTimerStart = false
var isAttack = false
var target = null
var target_queue = Queue.new()

func _ready():
	#resource에서 넘겨받은 것들 집어넣기 
	unit_tag = _status.unit_tag
	health = _status.health
	speed = _status.speed
	attack_damage = _status.attack_damage
	attack_type = _status.attack_type
	ads = _status.ads
	mana = _status.mana
	
	get_parent().rotates = false
	get_parent().cubic_interp = false
	get_parent().loop = false
	
	#시작 좌표 설정 / topLane, bottomLane에 배치하는 로직도 짜야 함 
	if unit_tag == "ally":
		get_parent().progress_ratio = 0.0
	if unit_tag == "enemy":
		get_parent().progress_ratio = 1.0
		
	#collision layer 설정 
	if get_parent().get_parent().get_name() == "bottomLane":
		get_parent().get_node("hitbox").set_collision_mask_value(1, false)
		get_parent().get_node("hitbox").set_collision_mask_value(2, true)
		
func _process(delta):
	stateSetter(delta)
	checkHealth()

#캐릭터 상태 설정
func stateSetter(delta): #state: move, engage
	if state == "move":
		move(delta)
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
				
#자동이동 및 걷기 애니메이션 
func move(delta):
	if unit_tag == "ally":
		get_parent().progress_ratio += MOVEMENT_VALUE * speed
	elif unit_tag == "enemy": 
		get_parent().progress_ratio -= MOVEMENT_VALUE * speed
	get_parent().get_node("AnimatedSprite2D").play("walk")
	
func engage(target):
	if combat_state == "cooldown":
		get_parent().get_node("AnimatedSprite2D").play("idle")
		if isAttackTimerStart == false:
			$attack_timer.start(ads * 0.4)
			isAttackTimerStart = true
		await $attack_timer.timeout
		combat_state = "attack"
	elif combat_state == "attack":
		get_parent().get_node("AnimatedSprite2D").play("attack") 
		await get_parent().get_node("AnimatedSprite2D").animation_finished
		if isAttack == false:
			if is_instance_valid(target):
				target.get_parent().get_node("engageComponent").health -= attack_damage #연산 
				print(target.get_parent().get_node("engageComponent").health)
			isAttack = true
		await get_parent().get_node("AnimatedSprite2D").animation_finished
		combat_state = "cooldown"
		isAttackTimerStart = false
		isAttack = false

#attackRangeComponent에서 시그널을 받아서 동작
#queue 구현해야 함. target[]에서 enemy 감지시 target에 들어감. target이 빈 리스트가 아니면 engage 
func attack_range_entered(area):
	if unit_tag == "ally":
		if area.get_name() == "hitbox":
			#사거리에 적이 들어오면 target_queue의 끝에 target ID 삽입 
			if area.get_parent().get_node("engageComponent").unit_tag == "enemy":
				target_queue.enqueue(area)
		
	elif unit_tag == "enemy":
		if area.get_name() == "hitbox":
			if area.get_parent().get_node("engageComponent").unit_tag == "ally":
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
		get_parent().get_node("AnimatedSprite2D").play("idle")
		get_parent().get_node("AnimatedSprite2D").pause()
		for i in range(16):
			get_parent().get_node("AnimatedSprite2D").modulate.a -= 16 #천천히 안 사라짐 
		#await get_parent().get_node("AnimatedSprite2D").animation_finished #<- 뭔가 이상 ...
		get_parent().queue_free()
