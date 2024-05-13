extends Node

#상태이상 정의 
@export var isKnockBack : bool = false
@export var isStun : bool = false
@export var isSlow : bool = false
@export var isBurn : bool = false

#Setter
func setKnockBack(distanceRatio : float):
	isKnockBack = true
	
	var duration = 0.1
	var elapse_time = 0.0
	
	get_parent().force_change_state("Idle") #State를 Idle로 강제 변환 
	get_parent().get_node("Cast").initQueue() #target, targetQueue 초기화
	get_parent().off_attackRangeComponent() #attackRangeComponent 비활성화 
	
	#실제 넉백 구현 
	var pathfollow = get_parent().get_parent()
	if get_parent().get_faction() == "ally":
		while elapse_time < duration:
			elapse_time += get_process_delta_time()
			var t = elapse_time / duration
			if pathfollow.progress_ratio - distanceRatio * t > 0.0:
				pathfollow.progress_ratio -= distanceRatio * t #ratio에 마이너스 연산, ratio가 0보다 작아지면 0으로 만들기
			else:
				pathfollow.progress_ratio = 0.0
	else: 
		while elapse_time < duration:
			elapse_time += get_process_delta_time()
			var t = elapse_time / duration
			if pathfollow.progress_ratio + distanceRatio * t < 1.0:
				pathfollow.progress_ratio += distanceRatio * t #ratio에 마이너스 연산, ratio가 0보다 작아지면 0으로 만들기
			else:
				pathfollow.progress_ratio = 1.0

	#attackRangeComponent 활성화 
	get_parent().on_attackRangeComponent()
	
	#Move로 상태 전이
	get_parent().force_change_state("Move")
	
	#넉백 종료 
	isKnockBack = false
	
func setStun():
	isStun = true
	
func setSlow():
	isSlow = true
	
func setBurn():
	isBurn = true
