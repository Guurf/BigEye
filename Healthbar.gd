extends ProgressBar

@onready var timer = $Timer
@onready var damagebar = $Damagebar
var health = 0 : set = _set_health
var damagebar_goto = health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
	
	if health < prev_health:
		timer.start()
	else:
		damagebar.value = health

func init_health(_health):
	health = _health
	damagebar_goto = _health
	max_value = _health
	value = _health
	damagebar.max_value = _health
	damagebar.value = _health

func _process(delta):
	if damagebar.value != damagebar_goto:
		damagebar.value = lerpf(damagebar.value, damagebar_goto, 0.05)

func _on_timer_timeout():
	damagebar_goto = health-0.1
