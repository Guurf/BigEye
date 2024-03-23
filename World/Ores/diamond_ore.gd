extends Node3D
var hp
var max_hp
var material = "stone"
var scale_to = 1
var pitch
@onready var area_3d = $Area3D
@onready var healthbar = $SubViewport/Healthbar
@onready var mesh = $"Ore Mesh"
@onready var regen_timer = $"Regen Timer"
@onready var healthbar_sprite = $"Healthbar Sprite"
@onready var hit_sound = $"Hit Sound"

func _ready():
	$SubViewport.set_update_mode(SubViewport.UPDATE_WHEN_PARENT_VISIBLE)
	max_hp = 70.0
	hp = max_hp
	pitch = randi_range(max_hp, max_hp+3)
	healthbar.init_health(hp)
	healthbar_sprite.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0.0:
		destroy()
	else: mesh.scale = lerp(mesh.scale, Vector3(scale_to, scale_to, scale_to), 0.1)
	if regen_timer.time_left <= 0.0: _ready()

func hit(_type, _damage):
	if hp > 0:
		if _type == "material":
			hit_sound.pitch_scale = pitch
			hit_sound.play()
			if healthbar_sprite.visible == false: healthbar_sprite.visible = true
			hp -= _damage
			pitch = hp / (max_hp / 10) + 4
			healthbar.health = hp
			mesh.scale = Vector3(0.7, 0.7, 0.7)
			regen_timer.start()

func destroy():
	mesh.scale = lerp(mesh.scale, Vector3(0.2, 0.2, 0.2), 0.1)
	if mesh.scale.x <= 0.3: 
		Inventory.add_ore(3, 2)
		queue_free()
