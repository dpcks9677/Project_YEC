extends CastState

var castTarget : Area2D
@onready var anim = $"../../../AnimationPlayer" #경로가 확정된 노드에 한해 onready 사용 할 것.

@export var castData : attackTypeResource

@export var damage : int
@export var damageType : String
@export var cooltime : float

func _enter_tree():
	damage = castData.damage
	damageType = castData.damageType
	cooltime = castData.cooltime

func _ready():
	if get_parent().get_parent().get_parent().get_parent().get_name() == "topLane":
		get_node("splash").set_collision_mask_value(1, false)
		get_node("splash").set_collision_mask_value(2, true)
		get_node("splash").set_collision_layer_value(1, false)
		get_node("splash").set_collision_layer_value(2, true)
	elif get_parent().get_parent().get_parent().get_parent().get_name() == "bottomLane":
		get_node("splash").set_collision_mask_value(1, false)
		get_node("splash").set_collision_mask_value(3, true)
		get_node("splash").set_collision_layer_value(1, false)
		get_node("splash").set_collision_layer_value(3, true)

func Enter():
	pass

func Exit():
	pass
	
func Update(_delta: float):
	castTarget = get_parent().target
	anim.play("attack")
	waiting_animation()
	
func Physics_Update(_delta: float):
	pass

#function
func waiting_animation(): #await 키워드와 함께 사용 
	return anim.animation_finished


func _on_splash_area_entered(area):
	if area.get_name() == "hitbox":
		if self.get_parent().get_parent().get_faction() != area.get_parent().get_node("stateComponent").get_faction(): #아군 오사 방지 
			area.get_parent().get_node("stateComponent").damaged(damage)
			#베이스 공격시 error방지용 코드 (base의 stateComponent에는 health 인자가 없음 
			if area.get_parent().get_node("stateComponent").property_exists(area.get_parent().get_node("stateComponent"), "health"):
				print("splash damaged: ", area.get_parent().get_node("stateComponent").health)
