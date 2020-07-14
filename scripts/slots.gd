extends GridContainer

func _ready():
    assign_neighbors()

func assign_neighbors():
    for i in range(get_child_count()):
        var slot = get_child(i)
        #warning-ignore:integer_division
        var x = i % columns
        #warning-ignore:integer_division
        var y = i / columns
        var left_x = x - 1
        var right_x = x + 1
        var top_y = y - 1
        var bottom_y = y + 1
        if left_x >= 0: 
            slot.neighbors.left = get_slot(left_x, y)
        if right_x < columns: 
            slot.neighbors.right = get_slot(right_x, y)
        if top_y >= 0: 
            slot.neighbors.top = get_slot(x, top_y)
        if bottom_y < get_child_count() / columns: 
            slot.neighbors.bottom = get_slot(x, bottom_y)

func reset():
    for slot in get_children():
        slot.reset()

func get_slot(x ,y):
    return get_child(x + y * columns)

func is_complete():
    for slot in get_children():
        if slot.get_active_tiles().size() != 1:
            return false
    return true

func is_invalid():
    for slot in get_children():
        if slot.get_active_tiles().size() == 0:
            return true
    return false
