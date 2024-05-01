extends State
class_name Dead

func Enter():
	get_parent().get_parent().get_node("AnimationPlayer").play("dead")
	await waiting_animation()
	get_parent().get_parent().queue_free()

func Exit():
	pass
	
#function
func waiting_animation(): #await 키워드와 함께 사용 
	return get_parent().get_parent().get_node("AnimationPlayer").animation_finished
