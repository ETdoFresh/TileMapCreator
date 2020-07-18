extends Control

func _ready():
    for tile in $DeleteOverlay.get_children():
        var delete_button = tile.get_child(0)
        delete_button.connect("pressed", self, "delete_tile", [tile])

func delete_tile(tile):
    var i = tile.get_index()
    tile.queue_free()
    $Tileset.remove_tile($Tileset.tiles[i])
