extends stageLib

var timer = 0

func _ready():
	pass

func _process(delta):
	setNormalWave(delta) #delta로 초딩 스폰 제어 

func setNormalWave(delta):
	timer += delta
	if timer >= 1.0:
		timer = 0
		spawnTop("wolf")

