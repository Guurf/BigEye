extends TextureRect
@onready var materials = [$Coal, $Amber, $Jade, $Diamond, $Ruby, $Obsidian]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for mat in materials.size():
		var prev_text = materials[mat].text
		materials[mat].text = str(Inventory.inventory[mat])
		if prev_text != materials[mat].text:
			materials[mat].scale = Vector2(2.5, 2.5)
		if Inventory.inventory[mat] == 0: materials[mat].text = ""
