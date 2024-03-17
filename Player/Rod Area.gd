extends Area3D
@onready var rod = $"../../../Rod"
@onready var mesh = $MeshInstance3D


func _process(delta):
	mesh.visible = monitoring
