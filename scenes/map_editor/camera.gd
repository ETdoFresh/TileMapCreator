extends Camera2D

export var was_pressed = false

var zoomLevel = [0.0625, 0.125, 0.25, 0.50, 0.75, 1.00, 2.00, 4.00, 8.00, 16.00, 32.00]
var zoomIndex = 5

var event_start_position

var zoom_event_position
var camera_start_position
var camera_end_position

onready var background = get_node("Background")

func _ready():
    var _error = background.connect("gui_input", self, "handle_event")

func handle_event(event):
    if event is InputEventMouseButton:
        if not was_pressed:
            if event.pressed:
                camera_start_position = position
                event_start_position = event.global_position
                was_pressed = true
        elif not event.pressed:
            camera_start_position = null
            event_start_position = null
            was_pressed = false
    
    if event is InputEventMouseMotion:
        if event_start_position != null:
            var delta = event.global_position - event_start_position
            delta *= zoom.x
            position = camera_start_position - delta
    
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

func get_screen_position(event_position):
    return event_position + background.rect_position + position
