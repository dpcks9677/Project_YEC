extends Node
class_name resourceHandler

#마나 
@export var mana_lv : int
@export var mana_lv_cost : int
@export var max_mana : int 
@export var regen_mana : int 
@export var current_mana : int
@export var isManaCooldown : bool
@export var isManaUpgrade : bool

#인구 수 
@export var population_lv : int
@export var population_lv_cost : int
@export var max_population : int
@export var population : int 
@export var isPopulationFull : bool
@export var isPopUpgrade : bool

#공격력 계수 
@export var atk_lv : int
@export var atk_lv_cost : int
@export var atk_max_lv : int
@export var atk_multiplier : float
@export var isAttackUpgrade : bool

#체력
@export var allyBaseHealth : int
@export var enemyBaseHealth : int
	
func _init():
	#고정 값 대신 stage 별 기본 정보들을 참조해서 불러올 수 있도록 설계하기 
	
	#마나
	mana_lv = 1
	mana_lv_cost = 25 #마나 업그레이드 비용 공식 20 + 15 * (mana_lv - 1)
	max_mana = 30 #최대 마나량 공식: 30 + 15 * (mana_lv - 1)
	regen_mana = 2 #리젠 마나량 공식 만들기 
	current_mana = 20
	isManaUpgrade = false
	
	#인구 수 
	population_lv = 1
	population_lv_cost = 20 #인구 업그레이드 비용 공식 20 + 25 * (population_lv - 1)
	max_population = 10
	population = 0
	isPopulationFull = false
	isPopUpgrade = false
	
	#공격력 
	atk_lv = 1
	atk_max_lv = 3
	atk_multiplier = 1.0 + atk_lv * 0.1 #공격력 공식 = 100% + 10% * lv
	isAttackUpgrade = false
	
	#베이스 체력
	allyBaseHealth = 4000
	enemyBaseHealth = 4000
	
func _process(_delta):
	atkHandler()
	populationHandler()
	manaHandler()
	checkBaseHealth()
	
#마나에 관한 기능들을 처리 
func manaHandler():
	max_mana = 30 + 20 * (mana_lv - 1) #최대 마나량 공식, 최대량 갱신 
	mana_lv_cost = 20 + 15 * (mana_lv - 1)
	
	regen_mana = 2 + floor(mana_lv / 2)
	
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

func manaLevelUp():
	mana_lv += 1

#인구수에 관한 기능들을 처리 
func populationHandler():
	max_population = population_lv * 10 #인구수 공식 
	population_lv_cost = 20 + 25 * (population_lv - 1)
	
	if population >= population_lv * 10:
		isPopulationFull = true
	else:
		isPopulationFull = false
		
func decreasePopulation():
	population -= 1
	
func increasePopulation():
	population += 1
	
func popLevelUp():
	population_lv += 1

#공격력에 관한 기능들을 처리 
func atkHandler():
	pass
	
func doAttackUpgrade():
	pass

#베이스 체력 관련 처리 
func get_allyBaseHealth():
	$laneSetter/allyBase.get_health()
	
func get_enemyBaseHealth():
	$laneSetter/enemyBase.get_health()
		
func checkBaseHealth():
	pass
	
#getter 함수 모음
#mana관련 
func get_mana_lv():
	return mana_lv
	
func get_mana_lv_cost():
	return mana_lv_cost
	
func get_max_mana():
	return max_mana
	
func get_regen_mana():
	return regen_mana
	
func get_current_mana():
	return current_mana
	
func get_isManaUpgrade():
	return isManaUpgrade
	
#pop관련
func get_population_lv():
	return population_lv
	
func get_population_lv_cost():
	return population_lv_cost
	
func get_max_population():
	return max_population
	
func get_population():
	return population
	
func get_isPopulationFull():
	return isPopulationFull
	
func get_isPopUpgrade():
	return isPopUpgrade
	
#att 관련
func get_atk_lv():
	return atk_lv
	
func get_atk_lv_cost():
	return atk_lv_cost

#setter
#mana관련
func set_current_mana(value):
	current_mana = value
