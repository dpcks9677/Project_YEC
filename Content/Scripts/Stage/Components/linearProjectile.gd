extends Area2D

# Points and movement parameters
var start_point = position
var end_point = Vector2(400, 0)

var duration = 1.3  # Duration of the movement in seconds
var elapsed_time = 0.0 # = x

var directionValue : int #투사체 방향 

var isFire : bool
var isHitted : bool

func _ready():
	position = start_point  # Start at the first point
	isFire = false
	isHitted = false
	visible = true
	
	if get_parent().get_parent().get_parent().get_faction() == "ally":
		directionValue = 1
	else:
		directionValue = -1

func _process(delta):
	if get_parent().castTarget != null:
		get_start_point()
		get_end_point()

	if isFire == true:
		#파티클 초기화 
		for child in get_children():
			if child is GPUParticles2D:
				child.emitting = true
		
		if isHitted == false:
			visible = true
		else:
			get_node("CollisionShape2D").disabled = true
			get_node("splashArea/CollisionShape2D").disabled = false #여기서 실행이 되긴 한데 즉시 실행은 안 됨
			$Sprite2D.visible = false
		
		if elapsed_time < duration:
			elapsed_time += delta
			
			var length = abs(start_point.x - end_point.x)
			var height = -(start_point.y - end_point.y)
			
			var t = elapsed_time / duration  # Normalized time from 0 to 1
			var x = elapsed_time * length / duration
			var y = elapsed_time * height / duration
			#var angle = -cos(t * PI)
			#set_rotation(angle)

			position = Vector2(directionValue * x, y)  # Update position
		else:
			visible = false #collision을 보고 싶으면 true로 바꿀 것 
			
			for child in get_children(): #파티클 삭제 
				if child is GPUParticles2D:
					child.emitting = false
			
			isHitted = false
			isFire = false
			get_node("CollisionShape2D").disabled = false
			set_rotation(0)
			
			elapsed_time = 0.0 
			
			await get_tree().create_timer(0.5).timeout #n초 기다리기 
			get_node("CollisionShape2D").disabled = true
	else:
		visible = false
			
func switchFire():
	isFire = true

func get_start_point():
	start_point = get_parent().get_parent().get_parent().get_parent().global_position

func get_end_point():
	if get_parent().castTarget != null:
		end_point = get_parent().castTarget.get_parent().global_position #- $"../../../..".global_position
		end_point.x -= 10 #마진값 추가
