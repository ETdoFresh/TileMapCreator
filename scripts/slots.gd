extends GridContainer

func _ready():
    assign_neighbors()

func assign_neighbors():
    for i in range(get_child_count()):
        var slot = get_child(i)
        var x = i % columns
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

func get_slot(x ,y):
    return get_child(x + y * columns)
