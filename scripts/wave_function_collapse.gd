extends Node2D

signal next_step

const Slots = preload("res://scenes/slots.tscn")
const FadingSquare = preload("res://scenes/fading_square.tscn")

var is_running = false

onready var slots = $Slots

func _ready():
    fill_slots()
    #warning-ignore:return_value_discarded
    $UI/Solve.connect("pressed", self, "solve")
    #warning-ignore:return_value_discarded
    $UI/Step.connect("pressed", self, "step")
    #warning-ignore:return_value_discarded
    $UI/Reset.connect("pressed", self, "reset")

func _input(event):
    if event.is_action_pressed("reset"):
        reset()

func fill_slots():
    for slot in $Slots.get_children():
        for tile in $RuleViewer/Tileset.get_children():
            slot.add_child(tile.duplicate())
        slot.calculate_entropy()

func solve():
    var slot = select_lowest_entropy()
    while slot != null:
        slot.collapse()
        slot.collapse_neighbors($RuleViewer/Rules)
        if slots.is_invalid():
            slots.queue_free()
            slots = Slots.instance()
            add_child(slots)
            
        slot = select_lowest_entropy()
    
    if slots.is_complete():
        slots.add_constant_override("hseparation", 0)
        slots.add_constant_override("vseparation", 0)
        $UI/Step.disabled = true
        $UI/Solve.disabled = true

func step():
    if is_running:
        emit_signal("next_step")
        return
    
    $UI/Solve.disabled = true
    is_running = true
    var slot = select_lowest_entropy()
    if slot:
        slot.collapse()
        var fading_square = FadingSquare.instance()
        fading_square.position = slot.rect_global_position
        add_child(fading_square)
        yield(self, "next_step")
        slot.collapse_neighbors($RuleViewer/Rules)
        
        if slots.is_invalid():
            fading_square = FadingSquare.instance()
            fading_square.modulate.r = 1
            fading_square.modulate.g = 0
            fading_square.modulate.b = 0
            fading_square.position = slot.rect_global_position
            add_child(fading_square)
            $UI/Step.disabled = true
        
    is_running = false
    
    if slots.is_complete():
        slots.add_constant_override("hseparation", 0)
        slots.add_constant_override("vseparation", 0)
        $UI/Step.disabled = true

func select_lowest_entropy():
    var selection = null
    for slot in slots.get_children():
        if slot.get_child_count() > 1:
            if selection == null || slot.entropy < selection.entropy:
                selection = slot
    return selection

func reset():
    #warning-ignore:return_value_discarded
    get_tree().change_scene("res://scenes/wave_function_collapse.tscn")
