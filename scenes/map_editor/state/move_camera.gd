extends Node

var was_pressed = false
var camera_start_position
var event_start_position

onready var camera = get_node("../../Camera2D")

func _gui_input(event):
    if event is InputEventMouseButton:
        if not was_pressed:
            if event.pressed:
                camera_start_position = camera.position
                event_start_position = event.global_position
                was_pressed = true
        elif not event.pressed:
            camera_start_position = null
            event_start_position = null
            was_pressed = false
    
    if event is InputEventMouseMotion:
        if event_start_position != null:
            var delta = event.global_position - event_start_position
            delta *= camera.zoom.x
            camera.position = camera_start_position - delta
