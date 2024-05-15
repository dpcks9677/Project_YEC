extends CastState

var castTarget : Area2D
@onready var anim = $"../../../AnimationPlayer" #경로가 확정된 노드에 한해 onready 사용 할 것.

@export var castData : healTypeResource

@export var heal : int
@export var isHealArea : bool
@export var cooltime : float

func _enter_tree():
	heal = castData.heal
	isHealArea = castData.isHealArea
	cooltime = castData.cooltime

func _ready():
	if get_parent().get_parent().get_parent().get_parent().get_name() == "topLane":
		get_node("healBox").set_collision_mask_value(1, false)
		get_node("healBox").set_collision_mask_value(2, true)
		get_node("healBox").set_collision_layer_value(1, false)
		get_node("healBox").set_collision_layer_value(2, true)
	elif get_parent().get_parent().get_parent().get_parent().get_name() == "bottomLane":
		get_node("healBox").set_collision_mask_value(1, false)
		get_node("healBox").set_collision_mask_value(3, true)
		get_node("healBox").set_collision_layer_value(1, false)
		get_node("healBox").set_collision_layer_value(3, true)

func Update(_delta: float):
	castTarget = get_parent().target
	anim.play("cast")
	waiting_animation()
	
#function
func waiting_animation(): #await 키워드와 함께 사용 
	return anim.animation_finished

func _on_heal_box_area_entered(area):
	if area.get_name() == "hitbox":
		if self.get_parent().get_parent().get_faction() == area.get_parent().get_node("stateComponent").get_faction() and area.get_parent().get_node("stateComponent").get_type() != "building": #아군 유닛에게만 적용 
			area.get_parent().get_node("stateComponent").healed(heal)
			if area.get_parent().get_node("stateComponent").property_exists(area.get_parent().get_node("stateComponent"), "health"):
				print(area.get_parent().get_node("stateComponent").health)
