extends Node2D

#stat
@export var MAX_HEALTH = 1000
@export var BASIC_SPEED = 1

#combat state
@export var state = "move"
@export var combat_state = "peace"
var target = null

#data
var speed : int
var health : float

func _ready():
	health = MAX_HEALTH
	speed = BASIC_SPEED
	
func _process(delta):
	stateSetter()

#tag
func ally():
	pass

#캐릭터 상태 설정
func stateSetter():
	if state == "move":
		target = null
		combat_state = "peace"
		move()
	elif state == "engage":
		if target != null:
			engage(target)

#enemy / ally 태그에 따라 뒤집기 여부 적용하는 코드 추가하기
#우측 자동이동 및 걷기 애니메이션 
func move():
	get_parent().get_node("AnimatedSprite2D").flip_h = true
	get_parent().translate(Vector2(speed,0))
	get_parent().get_node("AnimatedSprite2D").play("walk")

func engage(target):
	if combat_state == "cooldown_start":
		get_parent().get_node("AnimatedSprite2D").play("idle")
		$attack_timer.start(2)
		combat_state = "cooldown"
	elif combat_state == "cooldown":
		pass #timer waiting
	elif combat_state == "attack_start":
		get_parent().get_node("AnimatedSprite2D").play("attack")
		if get_parent().get_node("AnimatedSprite2D").animation_finished:
			target.health -= 100 #연산 
			print(target.health)
		combat_state = "attack"
	elif combat_state == "attack":
		$cooldown_timer.start()
		await get_parent().get_node("AnimatedSprite2D").animation_finished
		get_parent().get_node("AnimatedSprite2D").play("idle")
		
func _on_hitbox_area_entered(area):
	if area.has_method("enemy"):
		if target == null:
			target = area
		state = "engage"
		combat_state = "cooldown_start"
		
func _on_hitbox_area_exited(area):
	await get_parent().get_node("AnimatedSprite2D").animation_finished
	state = "move"

func _on_attack_timer_timeout():
	combat_state = "attack_start"
	
func _on_cooldown_timer_timeout():
	combat_state = "cooldown_start"
