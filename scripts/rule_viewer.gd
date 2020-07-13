#warning-ignore-all: return_value_discarded

extends Control

func _ready():
    for tile in $Tileset.get_children():
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
    
    var index = tile.texture.get_meta("index")
    var directions = ["Top", "Right", "Bottom", "Left"]
    for direction in directions:

        for child in $Rule.get_node(direction).get_children():
            child.visible = true

        for i in range($Rule.get_node(direction).get_child_count()):
            if not $Rules.can_be_neighbor(index, direction.to_lower(), i):
                $Rule.get_node(direction).get_child(i).visible = false

func main_tile_pressed(_tile):
    $Tileset.visible = true
    $Rule.visible = false
