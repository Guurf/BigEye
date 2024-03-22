extends Node3D
@onready var world_environment = $"../WorldEnvironment"
@onready var world_environment_type = world_environment.environment
@onready var world_light = $"../DirectionalLight3D"
@onready var day_length = $"Day Length"
var day_sky = preload("res://World/Texture/env_sky_001_noon.png")
var night_sky = preload("res://World/Texture/env_sky_003_night.png")
var cycle = false

func _process(delta):
	if Input.is_action_just_pressed("ui_down"): 
		cycle = true
		day_length.start()
	if cycle:
		if day_length.time_left <= 0.01 and world_environment.environment.sky.sky_material.panorama == day_sky: 
			world_environment.environment.sky.sky_material.panorama = night_sky
			cycle = false
		world_light.light_energy = day_length.time_left / 10
		world_environment_type.background_energy_multiplier = 0.01 + day_length.time_left / 10
		print(day_length.time_left / 10)
