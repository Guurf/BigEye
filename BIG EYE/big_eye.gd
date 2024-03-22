extends Node3D
@onready var animation_player = $"Big Eye/AnimationPlayer"
@onready var orbital_spawner = $"Orbital Spawner"
@onready var ball_spawner = $"Ball Spawner"

@onready var orbital_spawn_speed = $orbital_spawn_speed



var state = "asleep"
var current_attack
var upcoming_attacks = []
var phase_length = 3
var possible_attacks = 2 #+1 cause start from 0
var attack_delay = 4.0
var attacking = false

var orbital_spawn_amount = 3.0
var orbital_spawn = orbital_spawn_amount


func _ready():
	animation_player.play("idle")

func _process(delta):
	if Input.is_action_just_pressed("devF"): state = "choose"
	
	if state == "choose":
		randomize()
		if upcoming_attacks.size() < phase_length-1:
			for p in phase_length:
				var next_attack = 0
				upcoming_attacks.append(next_attack)
				p += 1
				print(upcoming_attacks)
		else:
			state = "attack"
	
	if state == "attack":
		if upcoming_attacks.size() > 0:
			if upcoming_attacks[0] == 0: _orbital_laser()
			elif upcoming_attacks[0] == 1: _eye_laser()
			elif upcoming_attacks[0] == 2: _laser_balls()
		else:
			state == "idle"
	
	if state == "idle":
		var idle_time = randf_range(2.0, 5.0)
		await get_tree().create_timer(idle_time).timeout
		state = "choose"
	
	if state == "pause":
		pass

func _orbital_laser():
	print(orbital_spawn)
	if orbital_spawn > 0 and orbital_spawn_speed.is_stopped():
		orbital_spawner.gen_random_pos()
		orbital_spawn -= 1
		orbital_spawn_speed.start()
	elif orbital_spawn <= 0:
		_next_attack()

func _eye_laser():
	print("EYE LASER")
	_next_attack()

func _laser_balls():
	ball_spawner._spawn_balls(5)
	_next_attack()

func _next_attack():
	state = "pause"
	await get_tree().create_timer(attack_delay).timeout
	upcoming_attacks.remove_at(0)
	_reset_attack_variables()
	state = "attack"

func _reset_attack_variables():
	orbital_spawn = orbital_spawn_amount
	orbital_spawn_speed.stop()

func _sleep():
	animation_player.play_backwards("open")

func _wake():
	animation_player.play("open")
	if !animation_player.is_playing():
		state = "choose"
