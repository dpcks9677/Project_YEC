extends Node
class_name stageLib 

func spawnTop(unitName):
	var unitData = load("res://Content/Scenes/Units/enemy/" + unitName + ".tscn").instantiate()
	
	get_parent().get_node("laneSetter").get_node("topLane").add_child(unitData)
	get_parent().get_node("HUD").get_node("minimapUI").spawnMarker(unitData)

func spawnBottom(unitName):
	var unitData = load("res://Content/Scenes/Units/enemy/" + unitName + ".tscn").instantiate()
	
	get_parent().get_node("laneSetter").get_node("bottomLane").add_child(unitData)
	get_parent().get_node("HUD").get_node("minimapUI").spawnMarker(unitData)
