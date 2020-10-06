extends Control

var size = Vector2.ZERO
var grid_size = 64
var x_positions = []
var y_positions = []
var tiles = []

func add_tile(position, tile):
    if tile == null:
        return
    
    var x = int(floor(position.x))
    var y = int(floor(position.y))
    if exists_tile(x, y):
        overwrite_tile(x, y, tile)
    else:
        add_child(tile)
        x_positions.append(x)
        y_positions.append(y)
        tiles.append(tile)
        tile.set_non_blocking_behavior()
        tile.rect_position = Vector2(x * grid_size, y * grid_size)
        tile.rect_size = Vector2(grid_size, grid_size)

func exists_tile(x, y):
    for i in range(tiles.size()):
        if x == x_positions[i] and y == y_positions[i]:
            return true
    return false

func get_tile(x, y):
    for i in range(tiles.size()):
        if x == x_positions[i] and y == y_positions[i]:
            return tiles[i]
    return null

func overwrite_tile(x, y, tile):
    for i in range(tiles.size()):
        if x == x_positions[i] and y == y_positions[i]:
            #if tiles[i].texture != tile.texture:
                remove_child(tiles[i])
                add_child(tile)
                tiles[i] = tile
                tile.set_non_blocking_behavior()
                tile.rect_position = Vector2(x * grid_size, y * grid_size)
                tile.rect_size = Vector2(grid_size, grid_size)

func remove_tile(tile):
    for i in range(tiles.size() - 1, -1, -1):
        if tile == tiles[i]:
            remove_child(tiles[i])
            tiles.remove(i)
            x_positions.remove(i)
            y_positions.remove(i)

func remove_position(position):
    var x = int(floor(position.x))
    var y = int(floor(position.y))
    for i in range(tiles.size() - 1, -1, -1):
        if x == x_positions[i] and y == y_positions[i]:
            remove_child(tiles[i])
            tiles.remove(i)
            x_positions.remove(i)
            y_positions.remove(i)
