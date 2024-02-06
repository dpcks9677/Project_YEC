extends Node
class_name resourceHandler

#마나 
@export var mana_lv : int
@export var max_mana : int 
@export var regen_mana : int 
@export var current_mana : int
@export var isManaCooldown : bool

#공격력 계수 
@export var atk_lv : int
@export var atk_multiplier : float

#인구 수 
@export var population_lv : int
@export var population : int 
@export var isPopulationFull : bool

#체력
@export var allyBaseHealth : int
@export var enemyBaseHealth : int

func _ready():
	#고정 값 대신 stage 별 기본 정보들을 참조해서 불러올 수 있도록 설계하기 
	
	#마나
	mana_lv = 1
	max_mana = 25 #최대 마나량 공식 만들기 
	regen_mana = 2 #리젠 마나량 공식 만들기 
	current_mana = 0
	
	#공격력 
	atk_lv = 1
	atk_multiplier = 1.0 + atk_lv * 0.1 #공격력 공식 = 100% + 10% * lv
	
	#인구 수 
	population_lv = 1
	population = 0
	
	#베이스 체력
	allyBaseHealth = 4000
	enemyBaseHealth = 4000

func _process(delta):
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
	
#공격력에 관한 기능들을 처리 
func atkHandler():
	pass

#인구수에 관한 기능들을 처리 
func populationHandler():
	if population >= population_lv * 10:
		isPopulationFull = true
	else:
		isPopulationFull = false
		
func checkBaseHealth():
	pass
