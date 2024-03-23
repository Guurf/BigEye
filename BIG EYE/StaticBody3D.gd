extends StaticBody3D
@onready var big_eye = $"../../../../../.."


func hit(_type, _damage):
	big_eye.hit(_type, _damage)
