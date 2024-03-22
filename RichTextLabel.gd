extends Control
@onready var rich_text_label = $RichTextLabel

var message = ""

func _process(delta):
	rich_text_label.text = message
