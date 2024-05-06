extends Area2D

# Points and movement parameters
var start_point = position
var end_point = Vector2(0,0)
var height = 150.0
var duration = 0.5  # Duration of the movement in seconds
var elapsed_time = 0.0 # = x

var FIXED_VALUE = 100.0

var isFire : bool
var isHitted : bool

func _ready():
	position = start_point  # Start at the first point
	
	isFire = false
	isHitted = false
	visible = true

func _process(delta):
	if get_parent().castTarget != null:
		get_start_point()
		end_point = get_parent().castTarget.get_parent().global_position
		end_point.x += FIXED_VALUE
	
	if isFire == true:
		if isHitted == false:
			visible = true
		else:
			visible = false
			get_node("CollisionShape2D").disabled = true
			
		if elapsed_time < duration:
			elapsed_time += delta
			
			var length = abs(start_point.x - end_point.x)
			var t = elapsed_time / duration  # Normalized time from 0 to 1
			var x = elapsed_time * length / duration
			var y = -height * sin(elapsed_time * 2 * PI) #parabola 코드 참조해서 수정 필요 
			var angle = -cos(elapsed_time * 2 * PI)
			set_rotation(angle)

			position = Vector2(x, y)  # Update position
		else:
			#투사체 노드 위치 초기화 및 변수 초기화 
			position = Vector2(0,0) # Ensure the sprite ends at the exact end point
			height = randf_range(120, 160)
			
			elapsed_time = 0.0 
			position = start_point
			visible = false
			isHitted = false
			isFire = false
			
			get_node("CollisionShape2D").disabled = true
			
			set_rotation(0)
			
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