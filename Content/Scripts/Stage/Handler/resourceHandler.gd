extends Node
class_name resourceHandler

#마나 
@export var mana_lv : int
@export var max_mana : int 
@export var regen_mana : int 
@export var current_mana : int
@export var isManaCooldown : bool
@export var isManaUpgrade : bool

#공격력 계수 
@export var atk_lv : int
@export var atk_max_lv : int
@export var atk_multiplier : float
@export var isAttackUpgrade : bool

#인구 수 
@export var population_lv : int
@export var population : int 
@export var isPopulationFull : bool
@export var isPopUpgrade : bool

#체력
@export var allyBaseHealth : int
@export var enemyBaseHealth : int
	
func _init():
	#고정 값 대신 stage 별 기본 정보들을 참조해서 불러올 수 있도록 설계하기 
	
	#마나
	mana_lv = 1
	max_mana = 25 #최대 마나량 공식 만들기 
	regen_mana = 2 #리젠 마나량 공식 만들기 
	current_mana = 20
	isManaUpgrade = false
	
	#공격력 
	atk_lv = 1
	atk_max_lv = 3
	atk_multiplier = 1.0 + atk_lv * 0.1 #공격력 공식 = 100% + 10% * lv
	isAttackUpgrade = false
	
	#인구 수 
	population_lv = 1
	population = 0
	isPopulationFull = false
	isPopUpgrade = false
	
	#베이스 체력
	allyBaseHealth = 4000
	enemyBaseHealth = 4000
	
func _ready():
	#signal 연결
	get_node("HUD").get_node("upgradeUI").get_node("manaUpgradeButton").connect("manaUpgrade", doManaUpgrade)
	get_node("HUD").get_node("upgradeUI").get_node("popUpgradeButton").connect("popUpgrade", doPopUpgrade)
	get_node("HUD").get_node("upgradeUI").get_node("attackUpgradeButton").connect("attackUpgrade", doAttackUpgrade)

func _process(_delta):
	atkHandler()
	populationHandler()
	manaHandler()
	checkBaseHealth()
	
#마나에 관한 기능들을 처리 
func manaHandler():
	if isManaCooldown == false:
		if current_mana + regen_mana >= max_mana: #(현재마나 + 재생 될 마나)가 최대 마나보다 크다면 
			current_mana = max_mana
		else:
			current_mana += regen_mana
		$manaGenerator.start(1) #마나는 1초당 생성되므로 고정 값을 사용 함 
		isManaCooldown = true
	else: #마나가 쿨다운 중일 때는 아무것도 안 함.
		pass

func _on_mana_generator_timeout():
	isManaCooldown = false

func doManaUpgrade() -> void:
	isManaUpgrade = true
	await get_tree().create_timer(20).timeout #upgrade time = 20
	print("upgraded")
	isManaUpgrade = false
	mana_lv += 1

#공격력에 관한 기능들을 처리 
func atkHandler():
	pass
	
func doAttackUpgrade() -> void:
	isAttackUpgrade = true
	await get_tree().create_timer(20).timeout #upgrade time = 20
	isAttackUpgrade = false

#인구수에 관한 기능들을 처리 
func populationHandler():
	if population >= population_lv * 10:
		isPopulationFull = true
	else:
		isPopulationFull = false
		
func decreasePopulation():
	population -= 1
	
func doPopUpgrade() -> void:
	isPopUpgrade = true
	await get_tree().create_timer(20).timeout #upgrade time = 20
	isPopUpgrade = false

#베이스 체력 관련 처리 
func allyBaseDamage(damage):
	allyBaseHealth -= damage
	
func enemyBaseDamage(damage):
	enemyBaseHealth -= damage
		
func checkBaseHealth():
	pass
