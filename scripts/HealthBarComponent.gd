extends Control
class_name healthBarComponent

@export var engage_Component: engageComponent
@export var health : int

func _ready():
	#engageComponent에서 health 받아오기
	health = engage_Component.health
	$healthBar.max_value = health

func _process(_delta):
	setHealth()

func setHealth():
	health = engage_Component.health
	$healthBar.value = health
