extends Control

var step_yield

onready var slots = $Slots

func _ready():
    #warning-ignore:return_value_discarded
    $LoadTexture.connect("tiles_loaded", self, "start_wfc")

func start_wfc():
    $CalculatingRules.visible = true
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    
    var rule_viewer = Scene.RULE_VIEWER.instance()
    rule_viewer.load_tileset($LoadTexture.tileset)
    add_child(rule_viewer)
    rule_viewer.rect_position = Vector2(96, 96)
    rule_viewer.rect_size = Vector2(512, 512)
    
    fill_slots()
    #warning-ignore:return_value_discarded
    $UI/Solve.connect("pressed", self, "solve")
    #warning-ignore:return_value_discarded
    $UI/Step.connect("pressed", self, "step")
    #warning-ignore:return_value_discarded
    $UI/Reset.connect("pressed", self, "reset")
    
    $CalculatingRules.visible = false

func _input(event):
    if event.is_action_pressed("reset"):
        reset()

func fill_slots():
    for slot in $Slots.get_children():
        slot.clear()
        for tile in $RuleViewer/Tileset.tiles:
            slot.add_tile(tile.duplicate())
        slot.calculate_entropy()

func solve():
    while step_yield and step_yield.resume():
        pass
    
    step_yield = null
    
    if slots.is_complete() or slots.is_invalid():
        reset()
    
    var slot = select_lowest_entropy()
    while slot != null:
        slot.collapse()
        slot.collapse_neighbors($RuleViewer/Rules)
        if slots.is_invalid():
            reset()
            
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
        var fading_square = Prefab.FADING_SQUARE.instance()
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
                fading_square = Prefab.FADING_SQUARE.instance()
                fading_square.modulate.r = 1
                fading_square.modulate.g = 0
                fading_square.modulate.b = 0
                fading_square.position = slot.rect_global_position
                add_child(fading_square)
                $UI/Step.text = "Reset"
                yield()
                reset()
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
        if slot.tiles.size() > 1:
            if selection == null || slot.entropy < selection.entropy:
                selection = slot
    return selection

func reset():
    $Slots.reset()
    $UI/Step.text = "Step"
    $UI/Step.disabled = false
    $Slots.add_constant_override("hseparation", 2)
    $Slots.add_constant_override("vseparation", 2)
