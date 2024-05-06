extends Area2D

# Points and movement parameters
var start_point = position
var end_point = Vector2(400, 0)
var height = 1000.0
var duration = 2.0  # Duration of the movement in seconds
var elapsed_time = 0.0 # = x

var directionValue : int #투사체 방향 

var isFire : bool
var isHitted : bool

func _ready():
	position = start_point  # Start at the first point
	isFire = false
	isHitted = false
	visible = true
	
	if get_parent().get_parent().get_parent().get_Unit_tag() == "ally":
		directionValue = 1
	else:
		directionValue = -1

func _process(delta):
	if get_parent().castTarget != null:
		get_start_point()
		end_point = get_parent().castTarget.get_parent().global_position
		end_point.y += 500

	if isFire == true:
		if isHitted == false:
			visible = true
		else:
			get_node("CollisionShape2D").disabled = true
			get_node("splashArea/CollisionShape2D").disabled = false #여기서 실행이 되긴 한데 즉시 실행은 안 됨
			$Sprite2D.visible = false
			
		if elapsed_time < duration:
			elapsed_time += delta
			
			var length = abs(start_point.x - end_point.x)
			var t = elapsed_time / duration  # Normalized time from 0 to 1
			var x = elapsed_time * length / duration
			var y = -height * sin(t * PI)
			var angle = -cos(elapsed_time * PI)
			#set_rotation(angle)

			position = Vector2(directionValue * x, y)  # Update position
		else:
			visible = false
			get_node("CollisionShape2D").disabled = true
			isHitted = false
			isFire = false
			set_rotation(0)
			elapsed_time = 0.0 
			position = start_point
			
func switchFire():
	isFire = true

func get_start_point():
	start_point = get_parent().get_parent().get_parent().get_parent().global_position

func get_end_point():
	if get_parent().castTarget != null:
		end_point = get_parent().castTarget.get_parent().global_position

#signal
func _on_area_entered(area):
	if area == get_parent().castTarget:
		isHitted = true

func _on_splash_area_area_entered(area):
	print("boom") #여기 실행 안 됨 
