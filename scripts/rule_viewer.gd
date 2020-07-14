#warning-ignore-all: return_value_discarded

extends Control

func _ready():
    for tile in $Tileset.tiles:
        tile.connect("pressed", self, "tileset_pressed")
        $Rule/Top.add_child(tile.duplicate())
        $Rule/Right.add_child(tile.duplicate())
        $Rule/Bottom.add_child(tile.duplicate())
        $Rule/Left.add_child(tile.duplicate())
    
    $Rule/Main.connect("pressed", self, "main_tile_pressed")

func tileset_pressed(tile):
    $Tileset.visible = false
    $Rule.visible = true
    $Rule/Main.texture = tile.texture
    
    var index = $Tileset.get_tile_index(tile)
    var directions = ["Top", "Right", "Bottom", "Left"]
    for direction in directions:
        var slot = $Rule.get_node(direction)
        slot.reset()

        for i in range(slot.tiles.size()):
            if not $Rules.can_be_neighbor(index, direction.to_lower(), i):
                slot.disable(i)

func main_tile_pressed(_tile):
    $Tileset.visible = true
    $Rule.visible = false
