extends CharacterBody3D

#movement variables
var speed
var input_dir = Input.get_vector("left", "right", "up", "down")
const WALK_SPEED = 5.0
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 6.8
var sensitivity = 0.002
var gravity = 16
var was_on_floor = true
var jumps = 1
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var coyote_time = $coyote_time

#combat variables
var current_weapon = 1
var max_hp = 100
var hp = max_hp
var max_stam = 20
var stam = max_stam
var regen_stam = false
var clip_size = 12
var ammo = clip_size
@onready var i_frames = $i_frames
@onready var stamina_regen = $stamina_regen
@onready var scroll_speed = $scroll_speed

#bob variables
const BOB_FREQ = 1.8
const BOB_AMP = 0.06
var t_bob = 0.0

#fov variables
var base_fov = 75.0
const FOV_CHANGE = 1.5

@onready var player_ui = $"Player UI"

func _ready():
	player_ui.healthbar.init_health(hp)
	player_ui.staminabar.init_stamina(stam)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		

func _physics_process(delta):
	if not is_on_floor() and was_on_floor:
		coyote_time.start()
		print("walked off")
	elif is_on_floor():
		was_on_floor = true
		jumps = 1

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (coyote_time.time_left >= 0.01 or is_on_floor()) and jumps > 0:
		velocity.y = JUMP_VELOCITY
		jumps -= 1
	
	# Hangle Sprint.
	if Input.is_action_pressed("sprint") and Input.is_action_pressed("up") and stam > 0:
		speed = SPRINT_SPEED
		stam -= 3 * delta
		stamina_regen.start()
		player_ui.staminabar._set_stamina(stam)
	else:
		speed = WALK_SPEED
	if stamina_regen.is_stopped() and stam < max_stam: 
		stam += 5 * delta
		player_ui.staminabar._set_stamina(stam)

	# Scroll Weapons.
	if scroll_speed.time_left <= 0.0 and (Input.is_action_just_released("scroll") or Input.is_action_just_pressed("scrollQ")):
		scroll_speed.start()
		current_weapon = -current_weapon
		print(current_weapon)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 8.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 8.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 4.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 4.0)
	
	# Head Bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), WALK_SPEED, SPRINT_SPEED * 2)
	var target_fov = base_fov + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	if not is_on_floor():
		was_on_floor = false
		velocity.y -= gravity * delta


func _process(delta):
	move_and_slide()

func damage_player(_damage):
	if i_frames.is_stopped():
		i_frames.start()
		hp -= _damage
		player_ui.healthbar.health = hp

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
