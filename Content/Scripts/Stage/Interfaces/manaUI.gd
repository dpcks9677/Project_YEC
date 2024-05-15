extends Control

#resourceHandler 형식 선언
@export var rsc : resourceHandler

# Called when the node enters the scene tree for the first time.
func _ready():
	rsc = get_parent().get_parent()
	$manaBar.set_max(rsc.max_mana)
	$manaBar.set_value(0)

func _process(_delta):
	$manaBar.set_max(rsc.max_mana)
	displayMana()

#manaUI 관련 스크립트 
func displayMana():
	$manaLabel.text = str(rsc.current_mana, " / ", rsc.max_mana)
	$manaBar.set_value(rsc.current_mana)
