extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var rot = randi_range(0, 360)
	rotation.y = deg_to_rad(rot)
