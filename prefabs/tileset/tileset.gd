class_name Tileset
extends GridContainer

signal selection_changed(tile)

var all_tiles = []
var tiles = []
var selected

func _ready():
    for tile in get_children():
        if tile.has_signal("selected"):
            tile.connect("selected", self, "emit_selection_changed", [tile])
    
    for tile in get_children():
        if not tiles.has(tile):
            add_tile(tile)

func _process(_delta):
    if not visible:
        return
    
    columns = int(max(round(sqrt(tiles.size())), 1))

func emit_selection_changed(tile):
    selected = tile
    emit_signal("selection_changed", tile)

func add_tile(tile : Tile):
    if tile.get_parent() != null:
        tile.get_parent().remove_child(tile)
    
    if tile.has_signal("selected"):
        if not tile.is_connected("selected", self, "emit_selection_changed"):
            var _1 = tile.connect("selected", self, "emit_selection_changed", [tile])
    
    add_child(tile)
    tiles.append(tile)
    all_tiles.append(tile)

func remove_tile(tile : Tile):    
    tiles.erase(tile)
    if tile and tile.get_parent() == self:
        remove_child(tile)

func get_tile_index(tile):
    for i in range(all_tiles.size()):
        if all_tiles[i] == tile:
            return i
    return -1

func clear():
    for i in range(tiles.size() - 1, -1, -1):
        remove_tile(tiles[i])
    for i in range(all_tiles.size() - 1, -1, -1):
        all_tiles.remove(i)
    for i in range(get_child_count() - 1, -1, -1):
        get_child(i).free()
