extends Node3D
@onready var animation_player = $"Big Eye/AnimationPlayer"
@onready var orbital_spawner = $"Orbital Spawner"
@onready var ball_spawner = $"Ball Spawner"
@onready var eye_laser = $"Eye Laser"
@onready var pupil = $"Big Eye/Node2/eye/pupil2"

@onready var orbital_spawn_speed = $orbital_spawn_speed
@onready var ball_spawn_speed = $ball_spawn_speed

@onready var laser_speed = $laser_speed
var player
var healthbar
var in_arena = true

var hp = 400
var idle_time

var state = "asleep"
var current_attack
var upcoming_attacks = []
var phase_length = 3
var possible_attacks = 2 #+1 cause start from 0
var attack_delay = 4.0
var attacking = false

var orbital_spawn_amount = 3.0
var orbital_spawn = orbital_spawn_amount

var ball_spawn_amount = 2.0
var ball_spawn = ball_spawn_amount

var laser_shot = false


func _ready():
	animation_player.play("closed")
	player = get_tree().get_nodes_in_group("Player")[0]
	healthbar = player.player_ui.bossbar
	healthbar.init_health(hp)
	healthbar.visible = false

func _process(delta):
	if hp <= 0 and attacking:
		state = "dead"
		animation_player.play("death")
	if attacking:
		if state == "choose":
			if in_arena:
				randomize()
				if upcoming_attacks.size() < phase_length-1:
					for p in phase_length:
						var next_attack = randi_range(0, 2)
						upcoming_attacks.append(next_attack)
						p += 1
				else:
					state = "attack"
			else:
				orbital_spawner.speed = 1.0
				orbital_spawn_amount = 5.0
				upcoming_attacks.clear()
				upcoming_attacks.append(0)
				state = "attack"
		
		elif state == "attack":
			if upcoming_attacks.size() > 0:
				if upcoming_attacks[0] == 0: _orbital_laser()
				elif upcoming_attacks[0] == 1: _laser_balls()
				elif upcoming_attacks[0] == 2: _eye_laser()
			else:
				state = "idle"
				idle_time = randf_range(2.0, 5.0)
		
		elif state == "idle":
			if animation_player.current_animation != "idle": animation_player.play("idle")
			idle_time -= 1 * delta
			if idle_time <= 0.0:
				idle_time = 0
				state = "choose"
				_init_level()
		
		elif state == "pause":
			if animation_player.current_animation != "idle": animation_player.play("idle")
		
		elif state == "asleep":
			if !animation_player.is_playing():
				attacking = true
				state = "choose"
				animation_player.play("idle")
		
	if state == "dead":
		attacking = false
		healthbar.visible = false

func _orbital_laser():
	if animation_player.current_animation != "orbital": animation_player.play("orbital")
	if orbital_spawn > 0 and orbital_spawn_speed.is_stopped():
		orbital_spawner.gen_random_pos()
		orbital_spawn -= 1
		orbital_spawn_speed.start()
	elif orbital_spawn <= 0:
		_next_attack()

func _eye_laser():
	if animation_player.current_animation != "laser attack": animation_player.play("laser attack")
	if eye_laser.state == 2:
		_next_attack()
	elif eye_laser.state == 3:
		eye_laser._shoot()

func _laser_balls():
	if ball_spawn > 0 and ball_spawn_speed.is_stopped():
		ball_spawner._spawn_ball()
		ball_spawn -= 1
		ball_spawn_speed.start()
	elif ball_spawn <= 0 and not animation_player.is_playing():
		_next_attack()
	if animation_player.current_animation != "balls attack": animation_player.play("balls attack")

func _next_attack():
	state = "pause"
	await get_tree().create_timer(attack_delay).timeout
	upcoming_attacks.remove_at(0)
	_reset_attack_variables()
	if not in_arena: state = "choose"
	else: state = "attack"

func _reset_attack_variables():
	orbital_spawn = orbital_spawn_amount
	orbital_spawn_speed.stop()
	ball_spawn = ball_spawn_amount
	ball_spawn_speed.stop()
	laser_shot = false

func _sleep():
	healthbar.visible = false
	attacking = false
	if not animation_player.is_playing():
		state = "asleep"

func hit(_type, _damage):
	if (_type == "enemy"):
		hp -= _damage
		healthbar.health = hp
		pupil.scale = Vector3(0.7, 0.8, 1.0)
		if state == "asleep": 
			animation_player.stop()
			state = "choose"
			attacking = true
			healthbar.visible = true

func _wake():
	if not animation_player.is_playing():
		state = "choose"
		attacking = true
		healthbar.visible = true
	
func _init_level():
	if hp >= 400:
		orbital_spawner.speed = 2.0
		orbital_spawner.radius = 4.0
		orbital_spawn_amount = 3.0
		ball_spawner.ball_speed = 3.0
		ball_spawner.ball_max_health = 3.0
		ball_spawn_amount = 2.0
		eye_laser.aim_length.wait_time = 1.0
		attack_delay = 4.0
	elif hp >= 350:
		orbital_spawner.speed = 1.8
		orbital_spawner.radius = 4.5
		orbital_spawn_amount = 4.0
		ball_spawner.ball_speed = 3.5
		ball_spawner.ball_max_health = 5
		ball_spawn_amount = 3.0
		eye_laser.follow_speed = 0.8
		attack_delay = 3.7
	elif hp >= 200:
		orbital_spawner.speed = 1.5
		orbital_spawner.radius = 5
		orbital_spawn_amount = 4.0
		ball_spawner.ball_speed = 3.5
		ball_spawner.ball_max_health = 5
		ball_spawn_amount = 5.0
		eye_laser.aim_length.wait_time = 0.8
		attack_delay = 3.4
	elif hp >= 0:
		orbital_spawner.speed = 1.0
		orbital_spawner.radius = 5
		orbital_spawn_amount = 5.0
		ball_spawner.ball_speed = 4
		ball_spawner.ball_max_health = 8
		ball_spawn_amount = 6.0
		eye_laser.aim_length.wait_time = 0.6
		eye_laser.follow_speed = 0.7
		attack_delay = 3


func _on_arena_area_area_exited(area):
	in_arena = false


func _on_arena_area_area_entered(area):
	in_arena = true
