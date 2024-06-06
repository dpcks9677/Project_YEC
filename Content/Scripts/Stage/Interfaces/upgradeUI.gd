extends Control

@export var state : String

var rsc : resourceHandler

var manaButton : TextureButton
var popButton : TextureButton
var attButton : TextureButton

var isManaUpgradeProgress : bool = false
var isPopUpgradeProgress : bool = false
var isAttUpgradeProgress : bool = false

func _ready():
	rsc = $"../.."
	
	manaButton = get_child(0)
	popButton = get_child(1)
	attButton = get_child(2)
	
func _process(delta):
	get_node("manaUpgradeButton/manaTag/mana").text = str(rsc.get_mana_lv_cost())
	get_node("popUpgradeButton/manaTag/mana").text = str(rsc.get_population_lv_cost())

#function
func upgradeProgressTexture():
	$UpgradeProgress.set_visible(true) #sprite on
	$UpgradeProgress.set_value($UpgradeProgress.get_value()-2.25*10)

func do_modulate(button : TextureButton):
	button.modulate = Color(0.5, 0.5, 0.5, 1) #색조 변경 
	button.position.x -= 2
	button.position.y += 2
	
func undo_modulate(button : TextureButton):
	button.modulate = Color(1, 1, 1, 1) #색조 변경 (원래대로) 
	button.position.x += 2
	button.position.y -= 2

#button signal
func _on_mana_upgrade_button_button_down():
	do_modulate(manaButton)

func _on_mana_upgrade_button_button_up():
	undo_modulate(manaButton)
	if rsc.get_mana_lv() <= 5 and rsc.get_current_mana() >= rsc.get_mana_lv_cost() and !isManaUpgradeProgress:
		print(rsc.get_current_mana(), rsc.get_mana_lv_cost())
		rsc.set_current_mana(rsc.get_current_mana() - rsc.get_mana_lv_cost()) #마나지불
		manaButton.disabled = true
		$manaUpgradeButton/UpgradeProgress.visible = true
		
		# Timer 노드를 생성하고 설정
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 1.0  # 타이머 간격을 1초로 설정
		timer.autostart = true  # 노드가 활성화될 때 자동으로 시작
		timer.timeout.connect(_on_manaTimer_timeout)  # timeout 시그널 연결
		
		for i in range(30):
			timer.start()
			await timer.timeout
		
		rsc.manaLevelUp() #마나 레벨업 실행 
		
		manaButton.disabled = false
		$manaUpgradeButton/TextureProgressBar.value = rsc.get_mana_lv() #레벨값 반영 
		$manaUpgradeButton/UpgradeProgress.visible = false 
		$manaUpgradeButton/UpgradeProgress.value = 30
		timer.queue_free()
	else:
		print("Mana level has reached its maximum.")

func _on_manaTimer_timeout():
	$manaUpgradeButton/UpgradeProgress.value -= 1

func _on_pop_upgrade_button_button_down():
	do_modulate(popButton)

func _on_pop_upgrade_button_button_up():
	undo_modulate(popButton)
	
	if rsc.get_mana_lv() <= 5 and rsc.get_current_mana() >= rsc.get_population_lv_cost() and !isPopUpgradeProgress:
		rsc.set_current_mana(rsc.get_current_mana() - rsc.get_population_lv_cost()) #마나지불
		popButton.disabled = true
		$popUpgradeButton/UpgradeProgress.visible = true
		
		# Timer 노드를 생성하고 설정
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 1.0  # 타이머 간격을 1초로 설정
		timer.autostart = true  # 노드가 활성화될 때 자동으로 시작
		timer.timeout.connect(_on_popTimer_timeout)  # timeout 시그널 연결
		
		for i in range(30):
			timer.start()
			await timer.timeout
		
		rsc.popLevelUp() #마나 레벨업 실행 
		
		popButton.disabled = false
		$popUpgradeButton/TextureProgressBar.value = rsc.get_population_lv() #레벨값 반영 
		$popUpgradeButton/UpgradeProgress.visible = false 
		$popUpgradeButton/UpgradeProgress.value = 30
		timer.queue_free()
	else:
		print("Population level has reached its maximum.")
	
func _on_popTimer_timeout():
	$popUpgradeButton/UpgradeProgress.value -= 1
	
	
	
func _on_attack_upgrade_button_button_down():
	do_modulate(attButton)

func _on_attack_upgrade_button_button_up():
	undo_modulate(attButton)
	
func _on_attTimer_timeout():
	$attUpgradeButton/UpgradeProgress.value -= 1
