extends Control
class_name healthBarComponent

@export var engage_Component: engageComponent
@export var health : int

func _ready():
	#engageComponent에서 health 받아오기 + 체력바 최대치 설정
	health = engage_Component.health
	$healthBar.max_value = health

func _physics_process(_delta):
	setHealth()

func setHealth(): #체력바 갱신 
	health = engage_Component.health
	$healthBar.value = health
