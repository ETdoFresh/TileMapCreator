tool
extends GridContainer

const GridBackgroundSquare = preload("res://scenes/map_editor/grid_background_square.tscn")

export var auto_populate = true
export var rows = 1

func _process(_delta):
    if not auto_populate:
        return
        
    while get_child_count() < rows * columns:
        var child = GridBackgroundSquare.instance()
        add_child(child)
    
    while get_child_count() > rows * columns:
        get_child(0).queue_free()
