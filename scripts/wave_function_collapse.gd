extends Node2D

signal next_step

const FadingSquare = preload("res://scenes/fading_square.tscn")

var is_running = false

func _ready():
    #warning-ignore:return_value_discarded
    $UI/Solve.connect("pressed", self, "solve")
    $UI/Step.connect("pressed", self, "step")

func solve():
    var slot = select_lowest_entropy()
    while slot != null:
        slot.collapse()
        slot.collapse_neighbors($Rules)
        slot = select_lowest_entropy()

func step():
    if is_running:
        emit_signal("next_step")
        return
    
    is_running = true
    var slot = select_lowest_entropy()
    if slot:
        slot.collapse()
        var fading_square = FadingSquare.instance()
        fading_square.position = slot.rect_global_position
        add_child(fading_square)
        yield(self, "next_step")
        slot.collapse_neighbors($Rules)
    is_running = false

func select_lowest_entropy():
    var selection = null
    for slot in $Slots.get_children():
        if slot.sprites.size() > 1:
            if selection == null || slot.entropy < selection.entropy:
                selection = slot
    return selection

func _input(event):
    if Input.is_key_pressed(KEY_R):
        get_tree().change_scene("res://scenes/wave_function_collapse.tscn")
