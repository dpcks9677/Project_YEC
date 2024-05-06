extends CastState

var castTarget : Area2D
@onready var anim = $"../../../AnimationPlayer" #경로가 확정된 노드에 한해 onready 사용 할 것.

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
	anim.play("attack")
	waiting_animation()

#function
func waiting_animation(): #await 키워드와 함께 사용 
	return anim.animation_finished

func get_damage():
	return get_parent().get_parent().attack_damage
#signal
func _on_damage_box_area_entered(area): #데미지 계산시에 활성화 됨. #area = 충돌된 콜리전, target = 공격대상 
	if area.get_name() == "hitbox":
		if self.get_parent().get_parent().get_Unit_tag() != area.get_parent().get_node("stateComponent").get_Unit_tag(): #아군 유닛 오사 방지
			area.get_parent().get_node("stateComponent").damaged(get_damage())
			print("spearman attack ",area.get_parent().get_node("stateComponent").health)


func _on_damage_box_area_exited(area):
	pass
