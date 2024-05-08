extends Node

@export var status : statusResource

var type : String
var faction : String
var health : int

func _enter_tree():
	type = status.type
	faction = status.faction
	health = status.health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#승패 판정 
	if health <= 0:
		if faction == "ally":
			print("you lose")
			get_tree().paused = true
		else:
			print("you win")
			get_tree().paused = true
			
#히트시 쉐이더 작동
func hitShader():
	var material = self.material
	if material is ShaderMaterial:
		material.set_shader_parameter("hit_modifier", 1)
		await get_tree().create_timer(0.1).timeout
		material.set_shader_parameter("hit_modifier", 0.3)
		await get_tree().create_timer(0.1).timeout
		material.set_shader_parameter("hit_modifier", 0)


func _on_state_component_ally_base_hitted(damage):
	hitShader()
	health -= damage
	print(health)


func _on_state_component_enemy_base_hitted(damage):
	hitShader()
	health -= damage
	print(health)
