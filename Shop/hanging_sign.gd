extends Node3D
@onready var sign_label = $"SubViewport/Sign Label"
@export var weapon = ""
@export var upgrade = ""
@onready var sub_viewport = $SubViewport

var player
var upgrade_tree_mats1 = [0, 0, 0]
var upgrade_tree_cost1 = [0, 0, 0]
var upgrade_tree_mats2 = [0, 0, 0]
var upgrade_tree_cost2 = [0, 0, 0]
var upg = "NONE"
var current = 0
func _ready():
	sub_viewport.set_update_mode(SubViewport.UPDATE_WHEN_PARENT_VISIBLE)
	player = get_tree().get_nodes_in_group("Player")[0]
	sign_label.weapon = weapon
	sign_label.upgrade = upgrade
	sign_label._init_sign()

func _update_upgrades():
	sign_label._init_upgrade(upgrade_tree_mats1[current], upgrade_tree_cost1[current], upgrade_tree_mats2[current], upgrade_tree_cost2[current])

func _buy():
	if (Inventory.inventory[upgrade_tree_mats1[current]] >= upgrade_tree_cost1[current]) and (Inventory.inventory[upgrade_tree_mats2[current]] >= upgrade_tree_cost2[current]):
		Inventory.inventory[upgrade_tree_mats1[current]] -= upgrade_tree_cost1[current]
		Inventory.inventory[upgrade_tree_mats2[current]] -= upgrade_tree_cost2[current]
		print(Inventory.inventory)
		current += 1
		if upg == "GUN DMG": #sign 1
			player.gun_dmg += 1.0
		
		elif upg == "GUN AMO": #sign 2
			player.clip_size += 2
		
		elif upg == "ROD DMG": #sign 3
			player.rod.rod_damage += 1
		
		elif upg == "ROD SPD": #sign 4
			player.rod.drill_speed.wait_time -= 0.05
		
		elif upg == "NONE":
			print("DO UPGRADE")
		_update_upgrades()
