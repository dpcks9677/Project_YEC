extends Area2D

# Points and movement parameters
var start_point = position
var end_point = Vector2.ZERO
var height = 200.0
var duration = 0.5  # Duration of the movement in seconds
var elapsed_time = 0.0

var directionValue : int
var FIXED_VALUE = 100.0

var isFire : bool
var isHitted : bool

func _ready():
	#position = start_point  # Start at the first point
	isFire = false
	isHitted = false
	visible = true

func _process(delta):
	if isFire == true:
		if isHitted == false:
			visible = true
		else:
			visible = true
	
		end_point = get_parent().castTarget.get_node("CollisionShape2D").global_position - $"../../../../hitbox/CollisionShape2D".global_position
		print(get_parent().castTarget.get_node("CollisionShape2D").global_position, $"../../../../hitbox/CollisionShape2D".global_position)
		
		if get_parent().get_parent().get_parent().get_faction() == "ally":
			end_point.x += FIXED_VALUE
		
		if elapsed_time < duration:
			elapsed_time += delta
			position = Vector2((end_point.x * (elapsed_time/duration)), (end_point.y * (elapsed_time/duration)) - sin(elapsed_time/duration * PI) * height)
		
			var angle = -cos(elapsed_time * 2 * PI)
			set_rotation(angle)
		else:
			position = Vector2(0,0) # Ensure the sprite ends at the exact end point
			visible = true #원래 false 
			isFire = false
			set_rotation(0)
			elapsed_time = 0.0
			position = start_point
	
func switchFire():
	isFire = true

func _on_area_entered(area):
	if area == get_parent().castTarget:
		isHitted = true
