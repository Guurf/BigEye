extends Node3D
@onready var area = $Area3D
@onready var mesh3D = $Area3D/MeshInstance3D
@onready var collision3D = $Area3D/CollisionShape3D


var player
var target_pos : Vector3
var current_width = 0.1
var laser_radius = 1.0
var follow_speed = 1.0
@onready var aim_length = $aim_length
@onready var shoot_length = $shoot_length
var state = 3

func _ready():
	current_width = 0.1
	mesh3D.mesh.top_radius = current_width
	mesh3D.mesh.bottom_radius = current_width
	collision3D.shape.radius = current_width
	area.monitoring = false
	visible = false
	player = get_tree().get_nodes_in_group("Player")[0]

func _shoot():
	state = 0
	current_width = 0.1
	target_pos = player.global_position
	area.monitoring = false
	visible = true
	aim_length.start()

func _process(delta):
	if state == 0:
		_aim_laser(delta)
		_update_radius()
	elif state == 1:
		_shoot_laser()
		_update_radius()
	elif state == 2:
		_end_laser()
		_update_radius()
		if current_width <= 0.01: state = 3
	elif state == 3:
		visible = false
		current_width = 0.1

func _aim_laser(delta):
	target_pos = lerp(target_pos, player.global_position, follow_speed * delta)
	look_at(target_pos) 
	if aim_length.time_left <= 0.01: 
		state = 1
		shoot_length.start()

func _shoot_laser():
	area.monitoring = true
	current_width = lerpf(current_width, laser_radius, 0.1)
	if shoot_length.time_left <= 0.01: state = 2

func _update_radius():
	mesh3D.mesh.top_radius = current_width
	mesh3D.mesh.bottom_radius = current_width
	collision3D.shape.radius = current_width

func _end_laser():
	area.monitoring = false
	current_width = lerpf(current_width, 0.0, 0.1)
	


func _on_area_3d_area_entered(area):
	area.get_parent().damage_player(20)
