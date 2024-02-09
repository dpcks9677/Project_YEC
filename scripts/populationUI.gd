extends Control

@export var rsc : resourceHandler

func _ready():
	rsc = get_tree().get_root().get_node("stage1").get_node("resourceHandler")

func _process(delta):
	displayPopulation()

func displayPopulation():
	if rsc.population < 10:
		get_node("populationLabel").text = str("0", rsc.population, "/", rsc.population_lv * 10)
	else:
		get_node("populationLabel").text = str(rsc.population, "/", rsc.population_lv * 10)
