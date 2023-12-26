extends Area2D

@export var speed = 1
@export var state = "move"
@export var combat_state = "peace"
@export var health = 500
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
	$AnimatedSprite2D.flip_h = false #뒤집기
	translate(Vector2(-speed,0))
	$AnimatedSprite2D.play("walk")
	
	
func engage(target): #area_entered에서 target의 정보 받아온 후 target의 체력에 피해 줌 
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

func enemy():
	pass

func _on_attack_range_area_entered(area):
	if area.has_method("ally"): #원하는 대로함 동작 안함 
		if target == null:
			target = get_parent().area
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
