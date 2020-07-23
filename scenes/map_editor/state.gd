extends Node

signal state_changed(previous_state, new_state)

var current
var states = []

func _ready():
    for state in get_children():
        states.append(state)
    
    for state in states:
        remove_child(state)
    
    set_state_by_index(0)
    

func _gui_input(event):
    if event is InputEventMouseButton:
        if name == "LeftClickState":
            if event.button_index == BUTTON_LEFT:
                current._gui_input(event)
        if name == "MiddleClickState":
            if event.button_index == BUTTON_MIDDLE:
                current._gui_input(event)
        if name == "RightClickState":
            if event.button_index == BUTTON_RIGHT:
                current._gui_input(event)
    else:
        current._gui_input(event)

func set_state(new_state):
    if current == new_state:
        return
    
    add_child(new_state)
    var previous_state = current
    current = new_state
    if previous_state != null:
        remove_child(previous_state)
    
    emit_signal("state_changed", previous_state, new_state)

func set_state_by_index(i):
    set_state(states[i])

func set_state_by_name(name):
    for state in states:
        if state.name == name:
            set_state(state)
            return
