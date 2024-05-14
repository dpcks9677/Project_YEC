extends State
class_name KnockBack

var MOVEMENT_VALUE = 0.0016

var duration : float
var distanceRatio : float

var timer : Timer

func Enter():
	get_parent().get_node("Cast").initQueue() #target, targetQueue 초기화
	get_parent().off_attackRangeComponent() #attackRangeComponent 비활성화 
	
	#timer 생성 후 카운트 시작 
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.1 
	timer.one_shot = true
	timer.timeout.connect(_on_Timer_timeout)
	timer.start()

func Exit():
	get_parent().on_attackRangeComponent() #attackRangeComponent 활성화 

	
func Update(_delta: float):
	if get_parent().get_faction() == "ally":
		pass
	else:
		get_parent().get_parent().progress_ratio += MOVEMENT_VALUE
		
func _on_Timer_timeout():
	timer.queue_free()
	get_parent().force_change_state("Move")
