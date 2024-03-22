extends Node3D
var inventory = [0, 0, 0, 0, 0, 0]

func add_item(_index):
	inventory[_index] += 1
	print(inventory)

func add_ore(_index, _drops):
	inventory[_index] += _drops
	print(inventory)
