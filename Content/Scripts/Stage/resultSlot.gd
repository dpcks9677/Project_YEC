extends NinePatchRect

@export var unitRes : Resource
var itemName : String

func _ready():
	unitRes = load("res://Content/Scripts/Resources/unitData/" + itemName + ".tres")
	$TextureButton/Sprite2D.texture = load("res://Content/Graphics/Sprites/portrait/" + itemName + ".png")
