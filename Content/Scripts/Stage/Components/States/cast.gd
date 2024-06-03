extends State
class_name Cast

#Attack queue
var target = null
var target_queue = Queue.new()

@export var cast_normal : CastState = null
@export var cast_skill1 : CastState = null

#공격횟수 카운트 
@export var attackCounter : int = 0

func _ready():
	for child in get_children():
		child.increaseAttackCounter.connect(_on_increaseAttackCounter)

func Enter():
	print("enter attack state succesfully")

#Attack일 때 실행되는 함수 
func Update(delta):
	if target_queue.get_head() != null and target == null: #타겟X, 타겟큐O
		target = target_queue.dequeue()
	elif target_queue.get_head() == null and target == null: #타겟X, 타겟큐X => Move로 전이 
		if $"../../AnimationPlayer".is_playing():
			$"../../AnimationPlayer".play("idle") #idle 재생 후 이동 
			await $"../../AnimationPlayer".animation_finished 
			get_parent().change_state(self, "Move")
	else: #타겟O
		if target not in $"../../attackRangeComponent".get_overlapping_areas(): #target이 공격범위 내 없는 경우 
			target = null
		else:
			cast_normal.Update(delta) #현재는 하드코딩
			if check_attackCounter(cast_skill1.get_triggerCount()) and cast_skill1 != null: #n-1타 후 n타 공격이 나가야 할 때 
				cast_skill1.Update(delta)

func Exit():
	pass

#function
func waiting_animation(): #await 키워드와 함께 사용 
	return get_parent().get_parent().get_node("AnimationPlayer").animation_finished
	
func initQueue():
	var target = null
	var target_queue = Queue.new()
	
#4타 검사 함수
func check_attackCounter(triggerCount):
	if attackCounter % triggerCount == triggerCount - 1:
		print("next attack will be stun attack")

#signal
func _on_attack_range_component_enqueue_target(object):
	target_queue.enqueue(object)
	get_parent().change_state(get_parent().get_node("Move"), "Cast")
	
func _on_increaseAttackCounter():
	attackCounter += 1
