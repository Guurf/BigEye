extends Camera3D
@onready var cooldown = $"../../Gun/gun cooldown"
@onready var animation_tree = $"../../Gun/pistol/AnimationTree"
@onready var player = $"../.."
@onready var hand = $Hand
@onready var shoot_sound = $"../../Shoot Sound"
@onready var empty_sound = $"../../Empty Sound"

var trail = preload("res://Player/bullet_trail.tscn").instantiate()
var ray_range = 2000

func get_camera_collision():
	player.ammo -= 1
	print(player.ammo)
	var shoot_pitch = randf_range(1.1, 1.2)
	shoot_sound.pitch_scale = shoot_pitch
	shoot_sound.play()
	var centre = get_viewport().get_size()/2
	
	var ray_origin = project_ray_origin(centre)
	var ray_end = ray_origin + project_ray_normal(centre)*ray_range
	var gun_origin = Vector3(hand.global_position.x, hand.global_position.y+0.15, hand.global_position.z)
	player.get_parent().add_child(trail)
	trail.init(gun_origin, ray_end)
	
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)

	if not intersection.is_empty():
		print(intersection.collider.collision_layer)
		if intersection.collider.collision_layer == 16:
			intersection.collider.hit("enemy", 1)
			print(intersection.collider)
	else:
		print("Nothing")



func _on_animation_tree_animation_started(anim_name):
	if anim_name == "shoot" and player.current_weapon == 1 and player.ammo > 0:
		get_camera_collision()
	elif player.ammo <= 0:
		player.ammo = 0
		empty_sound.play()
		
