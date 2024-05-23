extends stageLib

var timer = 0

func _ready():
	pass

func _process(delta):
	setNormalWave(delta) #delta로 초딩 스폰 제어 
	pass

func setNormalWave(delta):
	timer += delta
	if timer >= 10.0:
		timer = 0
		spawnTop("raptor")
		spawnBottom("raptor")
