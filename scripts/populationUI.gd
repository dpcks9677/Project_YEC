extends Control

@export var rsc : resourceHandler

func _ready():
	rsc = get_tree().get_root().get_node("stage1").get_node("resourceHandler")

func _process(delta):
	displayPopulation()

func displayPopulation():
	get_node("populationLabel").text = str("pop: ", rsc.population, " / ", rsc.population_lv * 10)
