extends Node2D
class_name engageComponent

@export var _status: statusResource

#stat
@export var unit_tag : String
@export var health : int
@export var speed : float
@export var attack_damage : int
@export var attack_type: bool

#combat state
@export var state = "move"
@export var combat_state = "peace"
var target = null
var target_queue = [] #null에서 리스트로 바꿔놓음 

func _ready():
	#resource에서 넘겨받은 것들 집어넣기 
	unit_tag = _status.unit_tag
	health = _status.health
	speed = _status.speed
	attack_damage = _status.attack_damage
	attack_type = _status.attack_type
	
func _process(_delta):
	stateSetter()
	checkHealth()

#캐릭터 상태 설정
func stateSetter():
	if state == "move":
		target = null
		combat_state = "peace"
		move()
	elif state == "engage":
		if target != null:
			engage(target)

#자동이동 및 걷기 애니메이션 
func move():
	if unit_tag == "ally":
		get_parent().translate(Vector2(speed,0))
	elif unit_tag == "enemy": 
		get_parent().translate(Vector2(-speed, 0))
	get_parent().get_node("AnimatedSprite2D").play("walk")
	

func engage(target):
	if combat_state == "cooldown_start":
		get_parent().get_node("AnimatedSprite2D").play("idle")
		$attack_timer.start(1) #공격 전 대기시간 
		combat_state = "cooldown"
	elif combat_state == "cooldown":
		pass #timer waiting
	elif combat_state == "attack_start":
		get_parent().get_node("AnimatedSprite2D").play("attack")
		if get_parent().get_node("AnimatedSprite2D").animation_finished:
			target.get_parent().get_node("engageComponent").health -= attack_damage #연산 
			print(target.get_parent().get_node("engageComponent").health)
		combat_state = "attack"
	elif combat_state == "attack":
		$cooldown_timer.start()
		await get_parent().get_node("AnimatedSprite2D").animation_finished
		get_parent().get_node("AnimatedSprite2D").play("idle")

#attackRangeComponent에서 시그널을 받아서 동작
#queue 구현해야 함. target[]에서 enemy 감지시 target에 들어감. target이 빈 리스트가 아니면 engage 
func attack_range_entered(area):
	if unit_tag == "ally":
		#사거리에 적이 들어오면 target_queue의 끝에 target ID 삽입 
		if area.get_parent().get_node("engageComponent").unit_tag == "enemy":
			target_queue[-1] = area #큐의 끝에 target ID 삽입 
		
		#전투 시스템은 다른 함수로 분리해야 할 것 같음. trigger가 다름
		#target이 null일 때 target_queue에서 다음 대상 불러오기 
		if target == null: #target이 없을 때 target_queue에서 다음 목표 불러오기, 없으면 peace로 상태변환 
			if target_queue[0] != null: #target_queue의 첫 번째 요소가 비어있지 않다면 
				target = target_queue.pop_front() #queue의 맨 앞을 target으로 pop
				state = "engage"
			else: #target도 null, target_queue도 null
				state = "peace"
		else: #target이 null이 아니면 cooldown_start 돌리기
			combat_state = "cooldown_start"
	elif unit_tag == "enemy":
		if area.get_parent().get_node("engageComponent").unit_tag == "ally":
			if target == null:
				target = area
			state = "engage"
			combat_state = "cooldown_start"

#attackRangeComponent에서 시그널을 받아서 동작
func attack_range_exited(area):
	await get_parent().get_node("AnimatedSprite2D").animation_finished
	state = "move"

func _on_attack_timer_timeout():
	combat_state = "attack_start"
	
func _on_cooldown_timer_timeout():
	combat_state = "cooldown_start"

func checkHealth():
	if health <= 0:
		#사망모션 추가 후 사망처리 부드럽게 처리 할 필요가 있음
		get_parent().queue_free()
