var id = -1
var texture: Texture
var stretch_mode = TextureRect.STRETCH_KEEP

# warning-ignore:shadowed_variable
static func set_id(tile, id):
    tile.id = id
    return tile

# warning-ignore:shadowed_variable
static func set_texture(tile, texture):
    tile.texture = texture
    return tile

# warning-ignore:shadowed_variable
static func set_stretch_mode(tile, stretch_mode):
    tile.stretch_mode = stretch_mode
    return tile
