extends Area2D

# Points and movement parameters
var start_point = position
var end_point = Vector2(400, 0)
var arc_height = 200.0
var duration = 0.5  # Duration of the movement in seconds
var elapsed_time = 0.0

var isFire : bool
var isHitted : bool

func _ready():
	position = start_point  # Start at the first point
	isFire = false
	isHitted = false
	visible = true

func _process(delta):
	if isFire == true:
		if isHitted == false:
			visible = true
		else:
			visible = false
			
		if elapsed_time < duration:
			elapsed_time += delta
			var t = elapsed_time / duration  # Normalized time from 0 to 1

			# Horizontal position interpolates linearly between start and end points
			var x = lerp(start_point.x, end_point.x, t)

			# Calculate the corresponding y position on the parabola
			# Vertex form of the parabola: y = a(x - h)^2 + k, where (h, k) is the vertex
			var h = (start_point.x + end_point.x) / 2.0  # Vertex x, midpoint of start and end x
			var k = min(start_point.y, end_point.y) - arc_height  # Vertex y, minimum y minus arc height
			var a = 4 * arc_height / (start_point.x - end_point.x) ** 2  # Solving for a given vertex and width of the parabola
			# Parabolic calculation for y
			var y = a * (x - h) ** 2 + k
			
			var velocity = 2 * a * (x-h)
			
			if velocity >= PI/2:
				set_rotation(PI/2)
			elif velocity <= -PI/2:
				set_rotation(-PI/2)
			else:
				set_rotation(velocity)
			
			position = Vector2(x, y)  # Update position
		else:
			position = Vector2(0,0) # Ensure the sprite ends at the exact end point
			visible = false
			isFire = false
			set_rotation(0)
			elapsed_time = 0.0
			position = start_point
	
func switchFire():
	isFire = true

func _on_area_entered(area):
	if area == get_parent().castTarget:
		isHitted = true
