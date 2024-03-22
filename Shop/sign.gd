extends StaticBody3D

@onready var animation_player = $"../hanging sign/AnimationPlayer"
@onready var sign = $".."

func hit(_type, _damage):
	sign._buy()
	animation_player.play("swing")
