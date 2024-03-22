extends StaticBody3D

@onready var animation_player = $"../hanging sign/AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(_type, _damage):
	animation_player.play("swing")
