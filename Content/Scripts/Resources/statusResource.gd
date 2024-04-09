extends Resource

class_name statusResource

#TAG
@export var unit_tag : String

#HP
@export var health : int

#SPEED
@export var speed : float

#MANA
@export var mana : int

#A SKILL DATA
@export var a_attack_damage : int
@export var a_attack_type : bool # 0 = physics / 1 = magic
@export var a_ads : float

#B SKILL DATA
@export var b_attack_damage : int
@export var b_attack_type : bool # 0 = physics / 1 = magic
@export var b_ads : float
