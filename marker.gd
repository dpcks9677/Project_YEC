extends PathFollow2D

var unitInfo

func _ready():
	pass

func _physics_process(_delta):
	if is_instance_valid(unitInfo):
		setProgression(unitInfo)

func setTarget(target):
	unitInfo = target

func setProgression(target):
	set_progress_ratio(target.progress_ratio)
