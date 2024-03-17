extends Node3D
var inventory = [0, 0, 0, 0]

func add_item(_index):
	inventory[_index] += 1
	print(inventory)

func add_ore(_index, _dropmin, _dropmax):
	var drops = randi_range(_dropmin, _dropmax)
	inventory[_index] += drops
	print(inventory)
