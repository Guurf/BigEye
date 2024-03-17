extends Node3D
@onready var world_environment = $"../WorldEnvironment"
@onready var world_environment_type = world_environment.environment
@onready var world_light = $"../DirectionalLight3D"
@onready var day_length = $"Day Length"
var cycle = false

func _process(delta):
	if Input.is_action_just_pressed("ui_down"): 
		cycle = true
		day_length.start()
	if cycle:
		world_light.light_energy = day_length.time_left / 10
		world_environment_type.background_energy_multiplier = 0.01 + day_length.time_left / 10
		print(day_length.time_left / 10)
