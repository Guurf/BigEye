extends Node3D
@onready var healthbar_sprite = $"Healthbar Sprite"
@onready var healthbar = $SubViewport/Healthbar
@onready var mesh = $Enemy/MeshInstance3D

var hp
var max_hp

func _process(delta):
	if hp <= 0.0:
		destroy()
	else: mesh.scale = lerp(mesh.scale, Vector3(1, 1, 1), 0.1)

func _ready():
	max_hp = 10
	hp = max_hp
	healthbar.init_health(hp)
	healthbar_sprite.visible = false

func hit(_type, _damage):
	if (_type == "enemy" or _type == "material"):
		if healthbar_sprite.visible == false: healthbar_sprite.visible = true
		hp -= _damage
		mesh.scale = Vector3(0.7, 1, 0.7)
		healthbar.health = hp

func destroy():
	mesh.scale = lerp(mesh.scale, Vector3(0.2, 0.2, 0.2), 0.1)
	if mesh.scale.x <= 0.3: 
		queue_free()
