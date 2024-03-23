extends CanvasLayer
@onready var healthbar = $Healthbar
@onready var staminabar = $Staminabar
@onready var clock = $Clock
@onready var bossbar = $Bossbar
@onready var ammo = $Ammo
@onready var sens_popup = $"Sens Popup"
@onready var pop_up = $pop_up

func _ready():
	sens_popup.visible = false

func changed_sens(_new_sens):
	sens_popup.visible = true
	sens_popup.text = "sens: "+ str(_new_sens*100)
	pop_up.start()

func _on_pop_up_timeout():
	sens_popup.visible = false
