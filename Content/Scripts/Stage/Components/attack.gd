extends State
class_name Attack

#Attack queue
var target = null
var target_queue = Queue.new()

func Enter():
	print("enter succesfully")
	
func Update(delta):
	#queue에서 target 추출 
	if target_queue._head != null and target == null:
		target = target_queue.dequeue()

func Exit():
	pass

	
func _on_attack_range_component_enqueue_target(object):
	target_queue.enqueue(object)
	get_parent().change_state(get_parent().get_node("Move"), "Attack") #signal을 stateComponent에 보내서 멈추도록 리빌딩 할 것 
