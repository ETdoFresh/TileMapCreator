extends GridContainer

export var auto_populate = true
export var rows = 1

func _process(_delta):
    if not auto_populate:
        return
        
    while get_child_count() < rows * columns:
        var child = Prefab.GRID_BACKGROUND_SQUARE.instance()
        add_child(child)
    
    while get_child_count() > rows * columns:
        get_child(0).queue_free()


func temp_paint(position, texture, color = Color.white):
    var x = int(floor(position.x))
    var y = int(floor(position.y))
    
    if x < 0 or y < 0 or x >= columns or y >= rows:
        return
    
    var i = x + y * columns
    var child = get_child(i)
    child.texture = texture
    child.modulate = color
