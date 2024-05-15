extends Node

@export var status : statusResource

var type : String
var faction : String
@onready var health : int

func _enter_tree():
	type = status.type
	faction = status.faction
	health = status.health

# Called when the node enters the scene tree for the first time.
func _ready():
	#Shader 불러오기 
	var base_shader = preload("res://Content/Scripts/Shader/hit.gdshader")
	
	var material = ShaderMaterial.new()
	material.shader = base_shader.duplicate()
	
	var R : float = 0.6509
	var G : float = 0.1333
	var B : float = 0.2549
	var A : float = 1.0
	
	material.set_shader_parameter("hit_color", Vector4(R, G, B, A))
	self.material = material

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

#getter
func get_health():
	return health
	
#히트시 쉐이더 작동
func hitShader():
	var material = self.material
	if material is ShaderMaterial:
		material.set_shader_parameter("hit_modifier", 1)
		await get_tree().create_timer(0.1).timeout
		material.set_shader_parameter("hit_modifier", 0.3)
		await get_tree().create_timer(0.1).timeout
		material.set_shader_parameter("hit_modifier", 0)

#signal
func _on_state_component_ally_base_hitted(damage):
	hitShader()
	health -= damage
	print(health)


func _on_state_component_enemy_base_hitted(damage):
	hitShader()
	health -= damage
	print(health)
