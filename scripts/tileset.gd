extends GridContainer

var tile_scene = preload("res://scenes/tile.tscn")
var tiles = []

func _ready():            
    for tile in get_children():
        tiles.append(tile)

func _process(_delta):
    if not visible:
        return
    
    columns = int(max(round(sqrt(tiles.size())), 1))
    
    while get_child_count() > tiles.size():
        remove_child(get_child(0))
        
    for _i in range (get_child_count(), tiles.size()):        
        add_child(tile_scene.instance())

func get_tile_index(tile):
    for i in range(tiles.size()):
        if tiles[i] == tile:
            return i
    return -1

func get_active_tiles():
    var active_tiles = []
    for tile in tiles:
        if not tile.ignore:
            active_tiles.append(tile)
    return active_tiles

func get_inactive_tiles():
    var active_tiles = []
    for tile in tiles:
        if tile.ignore:
            active_tiles.append(tile)
    return active_tiles
