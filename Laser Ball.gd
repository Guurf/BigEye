extends CharacterBody3D

var speed = 3
var accel = 10

var hp
var max_hp = 3.0
@onready var orb_owie = $"ORB OWIE"
@onready var sub_viewport = $SubViewport

@onready var nav: NavigationAgent3D = $NavigationAgent3D

@onready var healthbar_sprite = $"Healthbar Sprite"
@onready var healthbar = $SubViewport/Healthbar
@onready var mesh = $MeshInstance3D

func _ready():
	sub_viewport.set_update_mode(SubViewport.UPDATE_WHEN_PARENT_VISIBLE)
	hp = max_hp
	healthbar.init_health(hp)
	healthbar_sprite.visible = false

func _process(delta):
	if hp <= 0.0:
		destroy()
	else: mesh.scale = lerp(mesh.scale, Vector3(1, 1, 1), 0.1)

func _physics_process(delta):
	var direction = Vector3()
	var player = get_tree().get_nodes_in_group("Player")[0]
	
	nav.target_position = player.global_position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	move_and_slide()

func hit(_type, _damage):
	if (_type == "enemy"):
		if healthbar_sprite.visible == false: healthbar_sprite.visible = true
		hp -= _damage
		orb_owie.play()
		mesh.scale = Vector3(0.7, 1, 0.7)
		healthbar.health = hp

func destroy():
	mesh.scale = lerp(mesh.scale, Vector3(0.2, 0.2, 0.2), 0.1)
	if mesh.scale.x <= 0.3: 
		queue_free()


func _on_area_3d_area_entered(area):
	area.get_parent().damage_player(10)
