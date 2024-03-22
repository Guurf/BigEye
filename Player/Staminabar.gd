extends ProgressBar

@onready var timer = $Timer
var stamina = 0 : set = _set_stamina

func _set_stamina(new_stamina):
	var prev_stamina = stamina
	stamina = min(max_value, new_stamina)
	value = stamina
	
	if stamina <= 0:
		stamina == 0
	
	if stamina < prev_stamina:
		timer.start()
func init_stamina(_stamina):
	stamina = _stamina
	max_value = _stamina
	value = _stamina
