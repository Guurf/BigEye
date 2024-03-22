extends Control

@onready var upgrade_name = $"Upgrade Name"
@onready var rod_sprite = $"Rod Sprite"
@onready var gun_sprite = $"Gun Sprite"
@onready var material_sprite = $"Upgrade Name/Material1/Material Sprite"
@onready var material_sprite_2 = $"Upgrade Name/Material2/Material Sprite2"
@onready var upgrade_cost = $"Upgrade Name/Material1/Upgrade Cost"
@onready var upgrade_cost_2 = $"Upgrade Name/Material2/Upgrade Cost2"
@onready var material_1_node = $"Upgrade Name/Material1"
@onready var material_2_node = $"Upgrade Name/Material2"


var weapon = ""
var upgrade = ""

func _init_sign():
	if weapon == "Rod": rod_sprite.visible = true
	elif weapon == "Gun": gun_sprite.visible = true
	upgrade_name.text = upgrade

func _init_upgrade(_material1, _material1_amount, _material2, _material2_amount):
	material_sprite.texture.region = Rect2(48*_material1, 0, 48, 48)
	upgrade_cost.text = str(_material1_amount)
	if _material2 != 0:
		material_2_node.visible = true
		material_sprite_2.texture.region = Rect2(48*_material2, 0, 48, 48)
		upgrade_cost_2.text = str(_material2_amount)
	else: material_2_node.visible = false

