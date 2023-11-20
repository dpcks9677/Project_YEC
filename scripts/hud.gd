extends CanvasLayer

var character = preload("res://units/ally/walker.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	spawn()

func spawn():
	#인스턴스화
	var target = character.instantiate()
	
	#좌표 설정
	target.position.x = 0
	target.position.y = 360
	
	#stage1 씬에 노드 추가 
	get_tree().get_root().get_node("stage1").add_child(target)
	print("spawned")
