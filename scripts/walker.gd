extends Area2D

const speed = 1
var state = "move"
@export var combat_state = "peace"
@export var health = 300
var target = null

func _physics_process(delta):
	if state == "move":
		target = null
		combat_state = "peace"
		move(delta)
	elif state == "engage":
		if target != null:
			engage(target)
			
	if health <= 0:
		queue_free()

func move(delta):
	#우측 자동이동 및 걷기 애니메이션 
	translate(Vector2(speed,0))
	$AnimatedSprite2D.play("walk")
	
func engage(target):
		if combat_state == "cooldown_start":
			$AnimatedSprite2D.play("idle")
			$attack_timer.start(2)
			combat_state = "cooldown"
		elif combat_state == "cooldown":
			pass #timer waiting
		elif combat_state == "attack_start":
			$AnimatedSprite2D.play("attack")
			if $AnimatedSprite2D.animation_finished:
				target.health -= 100 #연산 
				print(target.health)
			combat_state = "attack"
		elif combat_state == "attack":
			$cooldown_timer.start()
			await $AnimatedSprite2D.animation_finished
			$AnimatedSprite2D.play("idle")

func ally():
	pass

func _on_attack_range_area_entered(area): # target이 공격범위에 있는데도 무시하는 현상 발생 -> 계속해서 공격체크 필요
	if area.has_method("enemy"):
		if target == null:
			target = area
		state = "engage"
		combat_state = "cooldown_start"

func _on_attack_range_area_exited(area):
	await $AnimatedSprite2D.animation_finished
	state = "move"

#공격 시 발동되는 타이머 
func _on_attack_timer_timeout():
	combat_state = "attack_start"

#공격 후 애니메이션 처리를 위해 발동되는 타이머 
func _on_cooldown_timer_timeout():
	combat_state = "cooldown_start"

#48 해결방안
#area에 들어오면
#queue에 target 정보 저장
#*중간에 exit 될 때(넉백 or 죽음) queue에서 삭제
#target == null 되면 queue에서 새로운 타깃 popup
