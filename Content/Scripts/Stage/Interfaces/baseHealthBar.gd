extends Control

@export var rsc : resourceHandler

@export var ALLY_MAX_HEALTH : int
@export var ENEMY_MAX_HEALTH : int
@export var allyHealth : int
@export var enemyHealth : int


func _ready():
	rsc = get_parent().get_parent()
	
	ALLY_MAX_HEALTH = rsc.allyBaseHealth
	ENEMY_MAX_HEALTH = rsc.enemyBaseHealth
		
	$allyHealthBar.max_value = ALLY_MAX_HEALTH
	$enemyHealthBar.max_value = ENEMY_MAX_HEALTH
	$allyHealthBar.value = rsc.allyBaseHealth
	$enemyHealthBar.value = rsc.enemyBaseHealth

func _physics_process(_delta):
	healthSetter()

func healthSetter():
	$allyHealthBar.value = rsc.allyBaseHealth
	$allyHealthLabel.text = str(rsc.allyBaseHealth)
	$enemyHealthBar.value = rsc.enemyBaseHealth
	$enemyHealthLabel.text = str(rsc.enemyBaseHealth)
