extends Node3D
@onready var mesh3D = $"Damage Area/MeshInstance3D"
@onready var collision = $"Damage Area/CollisionShape3D"
@onready var spot_light_3d_2 = $SpotLight3D2
@onready var control = $SubViewport/Control
@onready var damage_area = $"Damage Area"
var before_y
var radius = 5.0
var speed = 2.0
var speed_length = speed
var duration = 1.0
var current_radius = 0.0
var radius_speed = 0.2
var state = 0

var spawner_origin
var spawner_area

func _ready():
	spot_light_3d_2.visible = false
	collision.shape.radius = current_radius-0.5
	mesh3D.mesh.top_radius = current_radius
	mesh3D.mesh.bottom_radius = current_radius
	damage_area.monitoring = false


func _process(delta):
	if speed <= speed_length-0.1: spot_light_3d_2.visible = true
	if state == 0: 
		orbital_aim(delta)
		update_radius()
	elif state >= 1:
		orbital_attack(delta)
		update_radius()
	if state == 2:
		radius = 0.0
		spot_light_3d_2.visible = false
		if current_radius <= 0.1: queue_free()

func orbital_aim(delta):
	speed -= 1 * delta
	if speed <= 0.01: 
		state = 1
		speed = 0.0

func orbital_attack(delta):
	damage_area.monitoring = true
	current_radius = lerpf(current_radius, radius, radius_speed)
	duration -= 1 * delta
	if duration <= 0.01: 
		state = 2
		duration = 0.0

func update_radius():
	collision.shape.radius = current_radius-0.5
	mesh3D.mesh.top_radius = current_radius
	mesh3D.mesh.bottom_radius = current_radius

func _on_spread_area_area_entered(area):
	if speed >= speed_length-0.1:
		global_position.x = randi_range(spawner_origin.x, spawner_origin.x+spawner_area.x)
		global_position.z = randi_range(spawner_origin.z, spawner_origin.z+spawner_area.z)


func _on_damage_area_area_entered(area):
	area.get_parent().damage_player(10)
