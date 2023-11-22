extends Area2D

var health = 2000

func _ready():
	pass 

func _process(delta):
	check_destroyed()

func ally_base():
	pass

func check_destroyed():
	if health <= 0:
		print("you lose!")
		queue_free() #파괴모션 후 패배 출력으로 대체할 것 
