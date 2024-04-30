extends State
class_name Move

var MOVEMENT_VALUE = 0.0008
var speed : float

func _ready():
	speed = get_parent().get_speed()

func Enter():
	pass

#Move일 때 실행되는 함수 
func Update(delta):
	move()

func Exit():
	pass

func move():
	get_parent().get_parent().get_node("AnimationPlayer").play("walk")
	get_parent().get_parent().progress_ratio += MOVEMENT_VALUE * speed
