extends StaticBody3D
@onready var wall_slide = $"Wall Slide"
var start_y = position.y
@onready var big_eye = $"../../../Big eye"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if big_eye.hp <= 250:
		if position.y == start_y: 
			wall_slide.play()
		position.y = lerp(position.y, -5.0, 0.01)
