extends Node3D
@onready var animation_player = $"Mega Cog/AnimationPlayer"
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("float")
	player = get_tree().get_nodes_in_group("Player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(player.global_position)


func _on_area_3d_area_entered(area):
	player.win = true
