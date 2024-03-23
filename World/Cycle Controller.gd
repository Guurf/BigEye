extends Node3D
@onready var world_environment = $"../WorldEnvironment"
@onready var world_environment_type = world_environment.environment
@onready var world_light = $"../DirectionalLight3D"
@onready var day_length = $"Day Length"
@onready var player = $"../Player"

var day_sky = preload("res://World/Texture/env_sky_001_noon.png")
var night_sky = preload("res://World/Texture/env_sky_003_night.png")
var cycle = false
@onready var big_eye = $"../Big eye"

@export var gradient:GradientTexture1D
var time:float = 0.0
var value = 1.0
var night_time:float = 0.0
var skybox
var speed = 0.04 #0.04 night: 0.004


func _ready():
	skybox = world_environment.environment.sky.sky_material.panorama
	
func _process(delta):

	player.player_ui.clock.rotation = time-90 * (PI / 4.0)
	if value <= 0.005: 
		if player.hp <= 0:
			time = 0.01
		speed = 0.004
		if big_eye.state == "asleep": 
			big_eye._wake()
			big_eye.animation_player.play("open")
	else: 
		speed = 0.04
		if big_eye.state != "asleep": 
			big_eye._sleep()
			big_eye.animation_player.play_backwards("open")
	_day(delta)
	
	#skybox = night_sky
	#skybox = day_sky
#	if Input.is_action_just_pressed("ui_down"): 
#		cycle = true
#		day_length.start()
#	if cycle:
#		if day_length.time_left <= 0.01 and world_environment.environment.sky.sky_material.panorama == day_sky: 
#			world_environment.environment.sky.sky_material.panorama = night_sky
#			cycle = false
#		world_light.light_energy = day_length.time_left / day_length.wait_time
#		world_environment_type.background_energy_multiplier =  day_length.time_left / day_length.wait_time
#		print(day_length.time_left / day_length.wait_time)
#		else:
#			night_length.start()

func _day(delta):
	time += delta * speed
	value = (sin(time) + 1.0) / 2.0
	var col = gradient.gradient.sample(value)
	world_light.light_color = col
	world_environment_type.background_color = col
	world_environment_type.background_energy_multiplier = value
