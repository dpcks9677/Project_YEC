extends NinePatchRect

@onready var unitLoadout = $"../unitLoadout"
var itemName

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if unitLoadout.focusNode != null:
		itemName = unitLoadout.focusNode.get_itemName()
		
		var unitSprite = load("res://Content/Graphics/Sprites/portrait/" + itemName + ".png")
		var unitData = load("res://Content/Scripts/Resources/unitData/" + itemName + ".tres")
		var unitAttackData = load("res://Content/Scripts/Resources/castData/" + itemName + "_normal.tres")
		
		$itemName.text = " " + itemName
		$Slot.itemName = itemName
		$healthValue.text = str(unitData.health)
		$attackValue.text = str(unitAttackData.damage)
		$speedValue.text = str(unitData.speed)
		$manaValue.text = str(unitData.mana)
