extends Control

@export var rsc : resourceHandler

func _ready():
	rsc = get_parent().get_parent()

func _process(_delta):
	displayPopulation()
	displayAttack()

func displayPopulation():
	if rsc.population < 10: #01 처럼 표기하기 위해 if문 사용 
		$populationLabel.text = str("0", rsc.population, "/", rsc.population_lv * 10)
	else:
		$populationLabel.text = str(rsc.population, "/", rsc.population_lv * 10)
		
func displayAttack():
	$attackLabel.text = str(rsc.atk_lv, "/", rsc.atk_max_lv)

