extends Node3D
@onready var big_eye = $"../../../.."

func _process(delta):
	if scale != Vector3(1.0, 1.0, 1.0) and big_eye.state != "dead":
		scale = lerp(scale, Vector3(1.0, 1.0, 1.0), 0.1)
