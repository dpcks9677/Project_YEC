extends Node2D
class_name engageComponent

@export var _status: statusResource

#stat
@export var unit_tag : String
@export var health : int
@export var speed : float
@export var attack_damage : int
@export var attack_type: bool
@export var ads: float

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
	
	
func _process(_delta):
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
				
#자동이동 및 걷기 애니메이션 
func move():
	if unit_tag == "ally":
		get_parent().translate(Vector2(1,0)*speed)
	elif unit_tag == "enemy": 
		get_parent().translate(Vector2(-1, 0)*speed)
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
		#사거리에 적이 들어오면 target_queue의 끝에 target ID 삽입 
		if area.get_parent().get_node("engageComponent").unit_tag == "enemy":
			target_queue.enqueue(area)
		
	elif unit_tag == "enemy":
		if area.get_parent().get_node("engageComponent").unit_tag == "ally":
			target_queue.enqueue(area)

#attackRangeComponent에서 시그널을 받아서 동작
func attack_range_exited(area):
	await get_parent().get_node("AnimatedSprite2D").animation_finished

func checkHealth():
	if health <= 0:
		#사망모션 추가 후 사망처리 부드럽게 처리 할 필요가 있음
		get_parent().queue_free()
