extends Camera3D
@onready var cooldown = $"../../Gun/gun cooldown"
@onready var animation_tree = $"../../Gun/pistol/AnimationTree"
@onready var player = $"../.."

var ray_range = 2000

func get_camera_collision():
	var centre = get_viewport().get_size()/2
	
	var ray_origin = project_ray_origin(centre)
	var ray_end = ray_origin + project_ray_normal(centre)*ray_range
	
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if not intersection.is_empty():
		print(intersection.collider.collision_layer)
		if intersection.collider.collision_layer == 16:
			intersection.collider.get_parent().hit("enemy", 1)
	else:
		print("Nothing")



func _on_animation_tree_animation_started(anim_name):
	if anim_name == "shoot" and player.current_weapon == 1:
		get_camera_collision()
