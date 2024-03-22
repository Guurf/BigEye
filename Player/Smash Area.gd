extends Area3D


func smash():
	monitoring = true
	await get_tree().create_timer(0.2).timeout
	monitoring = false
