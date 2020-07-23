class_name TileRadio
extends TextureRectRadio

var tile

func init(init_tile = Prefab.UNKNOWN_TILE):
    tile = init_tile
    tile.connect("texture_changed", self, "change_texture")
    texture = tile.texture

func change_texture():
    texture = tile.texture
