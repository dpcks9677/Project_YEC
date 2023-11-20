extends CharacterBody2D

const speed = 50
var state = "move"

func _physics_process(delta):
	if state == "move":
		move(delta)
	elif state == "engage":
		engage()

func move(delta):
	#좌측 자동이동 및 걷기 애니메이션 
	velocity.x = -speed
	velocity.y = 0
	$AnimatedSprite2D.flip_h = false
	$AnimatedSprite2D.play("walk")
	
	move_and_slide()
	
func engage():
	#교전 시 애니메이션 
	velocity.x = 0
	velocity.y = 0
	$AnimatedSprite2D.flip_h = false
	$AnimatedSprite2D.play("attack")
	
	move_and_slide()
	

func enemy():
	pass

func _on_attack_range_body_entered(body):
	if body.has_method("ally"):
		state = "engage"


func _on_attack_range_body_exited(body):
	state = "move"
