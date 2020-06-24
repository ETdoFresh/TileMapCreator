extends Node2D

func _ready():
    #warning-ignore:return_value_discarded
    $UI/Solve.connect("pressed", self, "solve")

func solve():
    var slot = select_lowest_entropy()
    slot.collapse()
    #slot.collapse_neighbors()

func select_lowest_entropy():
    var selection = null
    for slot in $Slots.get_children():
        if slot.get_child_count() > 1:
            if selection == null || slot.entropy < selection.entropy:
                selection = slot
    return selection
