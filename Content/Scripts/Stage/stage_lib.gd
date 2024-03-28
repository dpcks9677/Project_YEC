class_name stageLib extends Node

func spawnTop(unitName):
	print("executed")
	var unitData = load("res://Content/Scenes/Units/enemy/" + unitName + ".tscn").instantiate()
	
	get_parent().get_node("laneSetter").get_node("topLane").add_child(unitData)
