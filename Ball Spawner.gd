extends Node3D
var laser_ball_scene = preload("res://BIG EYE/Attacks/laser_ball.tscn")
var x
var y
var z
var ball_speed = 3
var ball_max_health = 3.0
func _spawn_ball():
	z = randf_range(-2.5, 11.5)
	var side = randi_range(1, 2)
	if side == 1: 
		x = -20
		y = 0
	elif side == 2:
		x = 24.5
		y = 3
	var laser_ball = laser_ball_scene.instantiate()
	get_tree().get_root().add_child(laser_ball)
	laser_ball.speed = ball_speed
	laser_ball.max_hp = ball_max_health
	laser_ball.global_position = Vector3(x, y, z)
