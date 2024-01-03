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

func _ready():
	#resource에서 넘겨받은 것들 집어넣기 
	unit_tag = _status.unit_tag
	health = _status.health
	speed = _status.speed
	attack_damage = _status.attack_damage
	attack_type = _status.attack_type
	
func _process(_delta):
	stateSetter()

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
			#사망 체크 
			if health <= 0:
				dead()
			print(target.get_parent().get_node("engageComponent").health)
		combat_state = "attack"
	elif combat_state == "attack":
		$cooldown_timer.start()
		await get_parent().get_node("AnimatedSprite2D").animation_finished
		get_parent().get_node("AnimatedSprite2D").play("idle")

#attackRangeComponent에서 시그널을 받아서 동작
func attack_range_entered(area): ##자기 hitbox를 감지함 -> 감지 못하게 변경하기
	if unit_tag == "ally":
		if area.get_parent().get_node("engageComponent").unit_tag == "enemy":
			if target == null:
				target = area
			state = "engage"
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
	
func dead():
		get_parent().queue_free()
