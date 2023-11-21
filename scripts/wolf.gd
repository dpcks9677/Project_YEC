extends Area2D

const speed = 1
var state = "move"
#state flow peace -> cooldown -> attack -> end -> (feedback to cooldown) ...  -> peace
@export var combat_state = "peace" 
var target = null

func _physics_process(delta):
	if state == "move":
		target = null
		combat_state = "peace"
		move(delta)
	elif state == "engage":
		if target != null:
			engage(target)

func move(delta):
	#우측 자동이동 및 걷기 애니메이션 
	$AnimatedSprite2D.flip_h = false #뒤집기
	translate(Vector2(-speed,0))
	$AnimatedSprite2D.play("walk")
	
	
func engage(target): #area_entered에서 target의 정보 받아온 후 target의 체력에 피해 줌 
	if combat_state == "attack":
		translate(Vector2(0,0))
		$AnimatedSprite2D.play("attack")
		target.health -= 100
		print(target.health)
		combat_state = "end"
	elif combat_state == "cooldown":
		#$AnimatedSprite2D.play("idle")
		pass
	else:
		combat_state = "cooldown"
		$attack_timer.start()	

func enemy():
	pass

func _on_attack_range_area_entered(area):
	if area.has_method("ally"):
		state = "engage"
		target = area


func _on_attack_range_area_exited(area):
	state = "move"


func _on_attack_timer_timeout():
	combat_state = "attack"
