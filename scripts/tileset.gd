class_name Tileset
extends GridContainer

var tile_scene = preload("res://scenes/tile.tscn")

var tiles = []
var active_tiles = []
var inactive_tiles = []

func _ready():
    for tile in get_children():
        add_tile(tile)

func _process(_delta):
    if not visible:
        return
    
    columns = int(max(round(sqrt(active_tiles.size())), 1))

func add_tile(tile : Tile):
    if tile.get_parent() != self:
        add_child(tile)
    tiles.append(tile)
    if tile.enabled and not active_tiles.has(tile):
        active_tiles.append(tile)
    elif not tile.enable and not inactive_tiles.has(tile): 
        inactive_tiles.append(tile)
    #warning-ignore:return_value_discarded
    tile.connect("enabled_changed", self, "change_tile")

func remove_tile(tile : Tile):
    tiles.erase(tile)
    active_tiles.erase(tile)
    inactive_tiles.erase(tile)
    tile.disconnect("enabled_changed", self, "change_tile")
    tile.queue_free()

func change_tile(tile : Tile, enabled : bool):
    if enabled and not active_tiles.has(tile):
        active_tiles.append(tile)
    if enabled and inactive_tiles.has(tile):
        inactive_tiles.erase(tile)
    if not enabled and active_tiles.has(tile):
        active_tiles.erase(tile)
    if not enabled and not inactive_tiles.has(tile):
        inactive_tiles.append(tile)

func get_tile_index(tile):
    for i in range(tiles.size()):
        if tiles[i] == tile:
            return i
    return -1

func enable(tile : Tile):
    tile.enabled = true

func disable(tile : Tile):
    tile.enabled = false

func reset():
    for tile in tiles:
        tile.enabled = true
#    for i in range(tiles.size()):
#        if tiles[i].get_index() != i:
#            move_child(tiles[i], i)
