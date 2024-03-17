extends Node3D
@onready var mesh3D = $Area3D/MeshInstance3D
@onready var collision = $Area3D/CollisionShape3D
@onready var duration = $duration
@onready var spot_light_3d_2 = $SpotLight3D2

var radius
var current_radius = 0.0
var radius_speed = 0.2
var speed

func _ready():
	radius = 5.0
	collision.shape.radius = current_radius
	mesh3D.mesh.top_radius = current_radius
	mesh3D.mesh.bottom_radius = current_radius
	speed = 2.0

func _process(delta):
	if speed > 0.0: orbital_aim(delta)
	else:
		orbital_attack()
		update_radius()
		if duration.time_left <= 0.0:
			radius = 0.0
			if current_radius <= 0.1: queue_free()

func orbital_aim(delta):
	speed -= 1 * delta
	if speed <= 0.01: 
		duration.start()
		speed = 0.0

func orbital_attack():
	current_radius = lerpf(current_radius, radius, radius_speed)

func update_radius():
	collision.shape.radius = current_radius
	mesh3D.mesh.top_radius = current_radius
	mesh3D.mesh.bottom_radius = current_radius
	
