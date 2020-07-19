extends Camera2D

export var was_pressed = false

var zoomLevel = [0.0625, 0.125, 0.25, 0.50, 0.75, 1.00, 2.00, 4.00, 8.00, 16.00, 32.00]
var zoomIndex = 5

var start_posiiton = Vector2()
var event_position = Vector2()
var pointer_start_position = null

var zoom_event_position
var camera_start_position
var camera_end_position

func _gui_input(event):
    handle_event(event)

func handle_event(event):
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
        delta *= zoom.x
        position = start_posiiton - delta
    
    if event is InputEventMouseButton:
        if event.is_pressed():
            zoom_event_position = get_global_mouse_position()
            camera_start_position = position
            var previous_zoom_value = zoomLevel[zoomIndex]
            var delta = get_global_mouse_position() - position
            
            if event.button_index == BUTTON_WHEEL_UP:
                zoomIndex = clamp(zoomIndex - 1, 0, zoomLevel.size() - 1)
                var zoom_value = zoomLevel[zoomIndex]
                zoom = Vector2(zoom_value, zoom_value)
                position += delta * (previous_zoom_value - zoom_value) / previous_zoom_value
            if event.button_index == BUTTON_WHEEL_DOWN:
                zoomIndex = clamp(zoomIndex + 1, 0, zoomLevel.size() - 1)
                var zoom_value = zoomLevel[zoomIndex]
                zoom = Vector2(zoom_value, zoom_value)
                position += delta * (previous_zoom_value - zoom_value) / previous_zoom_value
