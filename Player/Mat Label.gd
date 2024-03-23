extends Label
var default_scale = Vector2(1.0, 1.0)

func _process(delta):
	if scale != default_scale: scale = lerp(scale, default_scale, 0.05)
