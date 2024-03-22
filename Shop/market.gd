extends Node3D

@onready var sign_1 = $Sign
@onready var sign_2 = $Sign2
@onready var sign_3 = $Sign3
@onready var sign_4 = $Sign4

# Called when the node enters the scene tree for the first time.
func _ready():
	sign_1.upgrade_tree_mats1 = [3, 0, 0] #0:Coal 1:Amber 2:Jade 3:Diamond 4:Ruby 5:Obsidian
	sign_1.upgrade_tree_cost1 = [3, 3, 3] #Amount
	sign_1.upgrade_tree_mats2 = [1, 1, 0] #0:Coal 1:Amber 2:Jade 3:Diamond 4:Ruby 5:Obsidian
	sign_1.upgrade_tree_cost2 = [9, 3, 0] #Amount
	sign_1.upg = "GUN DMG"
	sign_1._update_upgrades()
	
	sign_2.upgrade_tree_mats1 = [0, 0, 4]
	sign_2.upgrade_tree_cost1 = [18, 36, 10]
	sign_2.upgrade_tree_mats2 = [0, 1, 2]
	sign_2.upgrade_tree_cost2 = [0, 6, 1]
	sign_2.upg = "GUN AMO"
	sign_2._update_upgrades()
	
	sign_3.upgrade_tree_mats1 = [1, 0, 0]
	sign_3.upgrade_tree_cost1 = [12, 0, 0]
	sign_3.upgrade_tree_mats2 = [2, 0, 0]
	sign_3.upgrade_tree_cost2 = [2, 0, 0]
	sign_3.upg = "ROD DMG"
	sign_3._update_upgrades()
	
	sign_4.upgrade_tree_mats1 = [0, 0, 0]
	sign_4.upgrade_tree_cost1 = [15, 30, 0]
	sign_4.upgrade_tree_mats2 = [1, 2, 0]
	sign_4.upgrade_tree_cost2 = [3, 1, 0]
	sign_4.upg = "ROD SPD"
	sign_4._update_upgrades()
