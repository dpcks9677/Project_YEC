extends Node2D
class_name moveComponent


@export var speed = 1

func _physics_process(delta):
	move(delta)

func move(delta):
	translate(Vector2(-speed,0))
