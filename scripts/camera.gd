extends Camera2D

export var was_pressed = false

var start_posiiton = Vector2()
var event_position = Vector2()
var pointer_start_position = null

func _input(event):
	if event is InputEventScreenTouch:
		if not was_pressed:
			if event.pressed:
				start_posiiton = position
				pointer_start_position = event.position
				was_pressed = true
		elif not event.pressed:
			was_pressed = false
			pointer_start_position = null
			
	if pointer_start_position != null:
		var delta = event.position - pointer_start_position
		position = start_posiiton - delta
