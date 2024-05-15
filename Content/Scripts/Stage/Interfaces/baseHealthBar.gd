extends Control

@export var rsc : resourceHandler

@export var ALLY_MAX_HEALTH : int
@export var ENEMY_MAX_HEALTH : int
@export var allyHealth : int
@export var enemyHealth : int

@onready var allyBase = $"../../laneSetter/allyBase"
@onready var enemyBase = $"../../laneSetter/enemyBase"


func _ready():
	ALLY_MAX_HEALTH = allyBase.get_health()
	ENEMY_MAX_HEALTH = enemyBase.get_health()
		
	$allyHealthBar.max_value = ALLY_MAX_HEALTH
	$enemyHealthBar.max_value = ENEMY_MAX_HEALTH
	$allyHealthBar.value = ALLY_MAX_HEALTH
	$enemyHealthBar.value = ENEMY_MAX_HEALTH

func _physics_process(_delta):
	healthSetter()

func healthSetter():
	$allyHealthBar.value = allyBase.get_health()
	$allyHealthLabel.text = str(allyBase.get_health())
	$enemyHealthBar.value = enemyBase.get_health()
	$enemyHealthLabel.text = str(enemyBase.get_health())
