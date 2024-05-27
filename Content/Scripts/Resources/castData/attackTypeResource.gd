extends Resource
class_name attackTypeResource

#TAG
@export var damage : int
@export var damageType : String
@export var cooltime : float

#N trigger
@export var triggerCount : int = 1

#CC
@export var isStun : bool = false
@export var isSKnockBack : bool = false
@export var isSlow : bool = false
