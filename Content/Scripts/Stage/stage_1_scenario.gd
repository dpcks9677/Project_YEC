extends stageLib

var timer = 0

func _ready():
	pass

func _process(delta):
	timer += delta
	if timer >= 1.0:
		timer = 0
		setNormalWave()

func setNormalWave():
	spawnTop("rhino")

