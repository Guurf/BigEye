extends Node3D
@onready var sign_label = $"SubViewport/Sign Label"
@export var upgrade = "Heal"

var player
var cost = 6.0
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	sign_label.upgrade = upgrade
	sign_label._init_sign()
	sign_label._init_upgrade(-1, 0, 0, cost)

func _buy():
	if (Inventory.inventory[0] >= cost):
		player.hp = player.max_hp
		player.player_ui.healthbar.health = player.hp
		Inventory.inventory[0] -= cost
