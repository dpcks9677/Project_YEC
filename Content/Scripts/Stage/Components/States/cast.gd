extends State
class_name Cast

#Attack queue
var target = null
var target_queue = Queue.new()

func Enter():
	print("enter attack state succesfully")

#Attack일 때 실행되는 함수 
func Update(delta):
	if target_queue._head != null and target == null: #타겟X, 타겟큐O
		target = target_queue.dequeue()
	elif target_queue._head == null and target == null: #타겟X, 타겟큐X => Move로 전이 
		if $"../../AnimationPlayer".is_playing():
			pass
		else:
			get_parent().change_state(self, "Move")
	else: #타겟O
		if target not in $"../../attackRangeComponent".get_overlapping_areas(): #target이 공격범위 내 없는 경우 
			target = null
		else:
			get_child(0).Update(delta) #현재는 하드코딩

func Exit():
	pass

#function
func waiting_animation(): #await 키워드와 함께 사용 
	return get_parent().get_parent().get_node("AnimationPlayer").animation_finished
	
func initQueue():
	var target = null
	var target_queue = Queue.new()

#signal
func _on_attack_range_component_enqueue_target(object):
	target_queue.enqueue(object)
	get_parent().change_state(get_parent().get_node("Move"), "Cast")
