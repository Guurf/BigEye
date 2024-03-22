extends Node3D
@onready var spawn_area = $Area3D/CollisionShape3D.shape.size
@onready var origin = $Area3D/CollisionShape3D.global_position - spawn_area/2
var laser_scene = preload("res://BIG EYE/Attacks/orbital_laser.tscn")
var player

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	origin = $Area3D/CollisionShape3D.global_position - spawn_area/2
	global_position = player.global_position
#	if Input.is_action_just_pressed("devF"):
#		gen_random_pos()

func gen_random_pos():
	randomize()
	var x = randi_range(origin.x, origin.x+spawn_area.x)
	var z = randi_range(origin.z, origin.z+spawn_area.z)
	var laser = laser_scene.instantiate()
	get_tree().get_root().add_child(laser)
	laser.speed = 2.0
	laser.speed_length = laser.speed
	laser.duration = 0.5
	laser.radius = 4.0
	laser.global_position.x = x
	laser.global_position.z = z
	laser.global_position.y = player.global_position.y-2.5
	laser.spawner_origin = origin
	laser.spawner_area = spawn_area
  

