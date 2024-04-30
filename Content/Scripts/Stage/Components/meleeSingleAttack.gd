extends State
class_name Attack

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
		get_parent().change_state(self, "Move")
	else: #타겟O
		get_parent().get_parent().get_node("AnimationPlayer").play("attack")
		waiting_animation()

func Exit():
	pass

#function
func waiting_animation(): #await 키워드와 함께 사용 
	return get_parent().get_parent().get_node("AnimationPlayer").animation_finished
	
func get_damage():
	return get_parent().attack_damage

#signal
func _on_attack_range_component_enqueue_target(object):
	target_queue.enqueue(object)
	print(object)
	get_parent().change_state(get_parent().get_node("Move"), "Attack") #signal을 stateComponent에 보내서 멈추도록 리빌딩 할 것 

func _on_damage_box_area_entered(area): #데미지 계산시에 활성화 됨. #area = 충돌된 콜리전, target = 공격대상 
	if area == target and is_instance_valid(area):
		target.get_parent().get_node("stateComponent").damaged(get_damage())
		print(target.get_parent().get_node("stateComponent").health)
