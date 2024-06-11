extends stageLib

#enemyBase 체력은 시나리오에서 참조하도록 변경 

var availableWaves : Array = [1, 2, 3]
var usedWaves : Array = []

func _ready():
	#타이머 시작 
	$basicSpawner.wait_time = 15.0
	$basicSpawner.start()
	
	$waveSpawner.wait_time = 30.0
	$waveSpawner.start()
	
	await get_tree().create_timer(5).timeout #5초 후 랜덤한 라인에 스피터 소환 후 5초 뒤 반대 라인에 랩터 소환 
	if randi_range(0,1) == 0:
		spawnTop("spitter")
		await get_tree().create_timer(5).timeout
		spawnBottom("raptor")
	else:
		spawnBottom("spitter")
		await get_tree().create_timer(5).timeout
		spawnTop("raptor")

func _on_basic_spawner_timeout():
	var value = randomWaveValue()
	if value == 1: #raptor 상하부 하나
		spawnTop("spitter")
		spawnBottom("spitter")
	elif value == 2: #raptor 상부에 두개 
		spawnTop("raptor")
		await get_tree().create_timer(0.5).timeout #0.5초 대기후 한 마리 더
		spawnTop("raptor")
		#wait_time 길이 조절 코드 추가
	elif value == 3: #spitter 히부에 두개 
		spawnBottom("spitter")
		await get_tree().create_timer(0.5).timeout #0.5초 대기후 한 마리 더
		spawnBottom("spitter")
		
func _on_wave_spawner_timeout():
	if randi_range(0,1) == 0:
		spawnTop("smasher")
		await get_tree().create_timer(0.5).timeout #0.5초 대기후 한 마리 더
		spawnTop("spitter")
		await get_tree().create_timer(5).timeout #0.5초 대기후 한 마리 더
		spawnTop("raptor")
		spawnBottom("raptor")
	else:
		spawnBottom("smasher")
		await get_tree().create_timer(0.5).timeout #0.5초 대기후 한 마리 더
		spawnBottom("spitter")
		await get_tree().create_timer(5).timeout #0.5초 대기후 한 마리 더
		spawnBottom("raptor")
		spawnTop("raptor")
	
func randomWaveValue() -> int:
	#random값 다 사용시 초기화 
	if availableWaves.size() == 0:
		availableWaves = usedWaves.duplicate()
		usedWaves.clear()
	
	var randomIdx = randi() % availableWaves.size()
	var randomValue = availableWaves[randomIdx]
	
	usedWaves.append(randomValue)
	availableWaves.remove_at(randomIdx)
	
	return randomValue

