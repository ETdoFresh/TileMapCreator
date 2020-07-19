extends Control

const SLOTS = preload("res://scenes/wave_function_collapse_demo/slots.gd")
const FADING_SQUARE = preload("res://scenes/wave_function_collapse_demo/fading_square.tscn")

var step_yield

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
        slot.clear()
        for tile in $RuleViewer/Tileset.active_tiles:
            slot.add_tile(tile.duplicate())
        slot.calculate_entropy()

func solve():
    while step_yield and step_yield.resume():
        pass
    
    step_yield = null
    
    if slots.is_complete():
        reset()
    
    var slot = select_lowest_entropy()
    while slot != null:
        slot.collapse()
        slot.collapse_neighbors($RuleViewer/Rules)
        if slots.is_invalid():
            slots.queue_free()
            slots = SLOTS.instance()
            add_child(slots)
            
        slot = select_lowest_entropy()
    
    if slots.is_complete():
        slots.add_constant_override("hseparation", 0)
        slots.add_constant_override("vseparation", 0)
        $UI/Step.text = "Reset"

func step():
    if step_yield:
        step_yield = step_yield.resume()
    else:
        step_yield = step_solve()
    return

func step_solve():
    var slot = select_lowest_entropy()
    if slot:
        slot.collapse()
        var fading_square = FADING_SQUARE.instance()
        fading_square.position = slot.rect_global_position
        add_child(fading_square)
        
        if slots.is_complete():
            slots.add_constant_override("hseparation", 0)
            slots.add_constant_override("vseparation", 0)
            $UI/Step.text = "Reset"
            yield()
            reset()
        else:
            yield()
                
            slot.collapse_neighbors($RuleViewer/Rules)
            
            if slots.is_invalid():
                fading_square = FADING_SQUARE.instance()
                fading_square.modulate.r = 1
                fading_square.modulate.g = 0
                fading_square.modulate.b = 0
                fading_square.position = slot.rect_global_position
                add_child(fading_square)
                $UI/Step.disabled = true
            if slots.is_complete():
                slots.add_constant_override("hseparation", 0)
                slots.add_constant_override("vseparation", 0)
                $UI/Step.text = "Reset"
                yield()
                reset()
    else:
        reset()

func select_lowest_entropy():
    var selection = null
    for slot in slots.get_children():
        if slot.active_tiles.size() > 1:
            if selection == null || slot.entropy < selection.entropy:
                selection = slot
    return selection

func reset():
    $Slots.reset()
    $UI/Step.text = "Step"
    $UI/Step.disabled = false
    $Slots.add_constant_override("hseparation", 2)
    $Slots.add_constant_override("vseparation", 2)
