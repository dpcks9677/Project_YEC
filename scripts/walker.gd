extends CharacterBody2D

const speed = 50
var state = "move"

func _physics_process(delta):
	if state == "move":
		move(delta)
	elif state == "engage":
		engage()

func move(delta):
	#우측 자동이동 및 걷기 애니메이션 
	velocity.x = speed
	velocity.y = 0
	$AnimatedSprite2D.play("walk")
	
	move_and_slide()
	
func engage():
	#교전 시 애니메이션 
	velocity.x = 0
	velocity.y = 0
	$AnimatedSprite2D.flip_h = false
	$AnimatedSprite2D.play("attack")
	
	move_and_slide()

func ally():
	pass

func _on_area_2d_body_entered(body):
	if body.has_method("enemy"):
		state = "engage"
	
func _on_area_2d_body_exited(body):
	state = "move"
