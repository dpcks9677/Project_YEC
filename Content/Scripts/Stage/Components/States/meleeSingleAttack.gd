extends CastState

signal increaseAttackCounter

var castTarget : Area2D
@onready var anim = $"../../../AnimationPlayer" #경로가 확정된 노드에 한해 onready 사용 할 것.

@export var castData : attackTypeResource

@export var damage : int
@export var damageType : String
@export var cooltime : float

@export var triggerCount : int

@export var isStun : bool
@export var isKnockBack : bool
@export var isSlow : bool

func _enter_tree():
	damage = castData.damage
	damageType = castData.damageType
	cooltime = castData.cooltime
	
	triggerCount = castData.triggerCount
	
	isStun = castData.isStun
	isKnockBack = castData.isKnockBack
	isSlow = castData.isSlow
	
func _ready():
	if get_parent().get_parent().get_parent().get_parent().get_name() == "topLane":
		get_node("damageBox").set_collision_mask_value(1, false)
		get_node("damageBox").set_collision_mask_value(2, true)
		get_node("damageBox").set_collision_layer_value(1, false)
		get_node("damageBox").set_collision_layer_value(2, true)
	elif get_parent().get_parent().get_parent().get_parent().get_name() == "bottomLane":
		get_node("damageBox").set_collision_mask_value(1, false)
		get_node("damageBox").set_collision_mask_value(3, true)
		get_node("damageBox").set_collision_layer_value(1, false)
		get_node("damageBox").set_collision_layer_value(3, true)

func Update(_delta: float):
	castTarget = get_parent().target
	# castTarget의 state가 Dead면 Idle 모션 출력하기 / 다른 모든 타입에도 적용 
	if triggerCount == 1:
		anim.play("attack")
	else:
		anim.play("attack_knockback")
	waiting_animation()

func Exit():
	get_node("damageBox/CollisionShape2D").disabled = true

#function
func waiting_animation(): #await 키워드와 함께 사용 
	return anim.animation_finished
	
func knockBack():
	castTarget.get_parent().get_node("stateComponent").force_change_state("KnockBack") #거리값 추가 필요
	print("knockback executed")

#signal
func _on_damage_box_area_entered(area): #데미지 계산시에 활성화 됨. #area = 충돌된 콜리전, target = 공격대상 
	if area == castTarget and is_instance_valid(area):
		castTarget.get_parent().get_node("stateComponent").damaged(damage)
		$"../../../AudioStreamPlayer2D".play() #오디오 재생 
		
		#상태이상 추가 
		if isStun:
			pass
		if isKnockBack:
			knockBack()
		if isSlow:
			pass	
			
		if area.get_parent().get_node("stateComponent").property_exists(area.get_parent().get_node("stateComponent"), "health"):
			print(area.get_parent().get_node("stateComponent").health)
		
		await waiting_animation()
		emit_signal("increaseAttackCounter")
	else:
		#print(castTarget)
		pass

#getter
func get_triggerCount():
	return triggerCount
