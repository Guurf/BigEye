extends Node3D
@onready var hand = $"../Head/Camera3D/Hand"
@onready var camera = $"../Head/Camera3D"
@onready var player = $".."
@onready var animation_player = $"Cog Rod/AnimationPlayer"
@onready var animation_tree = $"Cog Rod/AnimationTree"
@onready var fall_counter = $"Fall Counter"
@onready var cooldown = $"rod cooldown"
@onready var drill_speed = $drill_speed
@onready var rod_area = $"../Head/Camera3D/Rod Area"
@onready var rod_area_attack = $"../Head/Camera3D/Rod Area Attack"
@onready var drill_sound = $"../Drill Sound"
@onready var node_priority = $"../Head/Camera3D/Node Priority"

var rod_damage = 2

var target_node = null
func _ready():
	animation_tree.active = true

func _process(delta):
	if player.current_weapon == -1: 
		visible = true
		global_position.x = lerp(global_position.x, hand.global_position.x, 1)
		global_position.y = hand.global_position.y
		global_position.z = hand.global_position.z
		rotation.x = camera.rotation.x
		update_animation_parameters()
		mining()
	else: visible = false


func update_animation_parameters():
	if (player.is_on_floor()):
		fall_counter.stop()
		animation_tree["parameters/conditions/is_falling"] = false
		if animation_tree["parameters/conditions/is_drilling"] == false:
			if animation_tree["parameters/conditions/plummeting"] == true:
				animation_tree["parameters/conditions/plummeting"] = false
				animation_tree["parameters/conditions/smash"] = true
				player.stam -= 10
				player.player_ui.staminabar._set_stamina(player.stam)
				player.stamina_regen.start()
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
		
		if (Input.is_action_just_pressed("shoot") and cooldown.time_left <= 0.0):
			animation_tree["parameters/conditions/thrust"] = true
			cooldown.start()
		elif (Input.is_action_pressed("shoot")) and cooldown.time_left <= 0.1 and animation_tree["parameters/conditions/thrust"] == true:
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/is_walking"] = false
			animation_tree["parameters/conditions/is_running"] = false
			animation_tree["parameters/conditions/thrust"] = false
			animation_tree["parameters/conditions/is_drilling"] = true
		elif not (Input.is_action_pressed("shoot")):
			animation_tree["parameters/conditions/thrust"] = false
			animation_tree["parameters/conditions/is_drilling"] = false
	else:
		if animation_tree["parameters/conditions/is_drilling"] == true or animation_tree["parameters/conditions/thrust"] == true:
			animation_tree["parameters/conditions/is_drilling"] = false
			animation_tree["parameters/conditions/thrust"] == false
			animation_tree["parameters/conditions/idle"] = true
		if (player.velocity.y < 0.0):
			if fall_counter.is_stopped() and animation_tree["parameters/conditions/is_falling"] == false: fall_counter.start()
			if fall_counter.time_left <= 0.01:
				animation_tree["parameters/conditions/is_falling"] = true
				animation_tree["parameters/conditions/is_running"] = false
				animation_tree["parameters/conditions/idle"] = false
				animation_tree["parameters/conditions/is_walking"] = false
				if (Input.is_action_just_pressed("shoot")):
					animation_tree["parameters/conditions/plummeting"] = true
		elif (Input.is_action_just_pressed("shoot") and cooldown.time_left <= 0.0):
			animation_tree["parameters/conditions/thrust"] = true
			cooldown.start()

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func mining():
	if animation_tree["parameters/conditions/is_drilling"] == true:
		if drill_speed.is_stopped(): drill_speed.start()
		if drill_speed.time_left >= drill_speed.wait_time-0.05: rod_area.monitoring = true
		else: rod_area.monitoring = false
	elif drill_speed.time_left <= 0.1:
		rod_area.monitoring = false
		drill_speed.stop()
	rod_area_attack.monitoring = rod_area.monitoring

func _on_rod_area_area_entered(area):
	var target = area.get_parent()
	target.hit("material", rod_damage)


func _on_rod_area_attack_area_entered(area):
	var target = area.get_parent()
	target.hit("enemy", rod_damage)
