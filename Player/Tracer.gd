extends MeshInstance3D
var tracer_mat = preload("res://Player/bullet trail.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(pos1, pos2):
	var draw_mesh = ImmediateMesh.new()
	tracer_mat.albedo_color = Color(255, 217, 0, 1)
	mesh = draw_mesh
	draw_mesh.surface_begin(Mesh.PRIMITIVE_LINES, tracer_mat)
	draw_mesh.surface_add_vertex(pos1)
	draw_mesh.surface_add_vertex(pos2)
	draw_mesh.surface_end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tracer_mat.albedo_color = lerp(tracer_mat.albedo_color, Color(255, 217, 0, 0), 0.5)  
