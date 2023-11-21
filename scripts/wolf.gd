extends Area2D

const speed = 1
var state = "move"

func _physics_process(delta):
	if state == "move":
		move(delta)
	elif state == "engage":
		engage()

func move(delta):
	#우측 자동이동 및 걷기 애니메이션 
	$AnimatedSprite2D.flip_h = false #뒤집기
	translate(Vector2(-speed,0))
	$AnimatedSprite2D.play("walk")
	
	
func engage():
	#교전 시 애니메이션 
	$AnimatedSprite2D.flip_h = false #뒤집기
	translate(Vector2(0,0))
	$AnimatedSprite2D.play("attack")
	

func enemy():
	pass

func _on_attack_range_area_entered(area):
	if area.has_method("ally"):
		state = "engage"

func _on_attack_range_area_exited(area):
	state = "move"
