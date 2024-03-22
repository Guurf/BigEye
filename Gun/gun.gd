extends Node3D
@onready var hand = $"../Head/Camera3D/Hand"
@onready var camera = $"../Head/Camera3D"
@onready var animation = $pistol/AnimationPlayer
@onready var animation_tree = $pistol/AnimationTree
@onready var player = $".."
@onready var cooldown = $"gun cooldown"

func _ready():
	animation_tree.active = true

func _process(delta):
	if player.current_weapon == 1: visible = true
	else: visible = false
	global_position.x = lerp(global_position.x, hand.global_position.x, 1)
	global_position.y = hand.global_position.y
	global_position.z = hand.global_position.z
	rotation.x = camera.rotation.x
	update_animation_parameters()

func update_animation_parameters():
	if (player.speed == player.SPRINT_SPEED):
		animation_tree["parameters/conditions/is_running"] = true
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_walking"] = false
	elif Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		animation_tree["parameters/conditions/is_walking"] = true
		animation_tree["parameters/conditions/is_running"] = false
		animation_tree["parameters/conditions/idle"] = false
	else:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/is_running"] = false
	
	if (Input.is_action_pressed("shoot") and cooldown.time_left <= 0.0):
		animation_tree["parameters/conditions/shoot"] = true
		cooldown.start()
	else:
		animation_tree["parameters/conditions/shoot"] = false
	
	if (Input.is_action_pressed("reload")):
		animation_tree["parameters/conditions/reload"] = true
		player.ammo = player.clip_size
	else:
		animation_tree["parameters/conditions/reload"] = false
