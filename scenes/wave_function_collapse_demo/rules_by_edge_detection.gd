extends Node2D

export var pixel_percentage_threshold = 0.75
export var color_match_threshold = 0.1

var rules = \
{
    "top": [],
    "right": [],
    "bottom": [],
    "left": [],
}
var image_data = null

onready var tileset = get_parent().get_node("Tileset")

func _ready():
    rules = match_edges(tileset)

# warning-ignore:shadowed_variable
func match_edges(tileset):
    var atlasTexture = tileset.tiles[0].texture
    var image = atlasTexture.atlas.get_data()
    image.lock()
    var size = image.get_size()
    image_data = []
    for x in range(size.x):
        image_data.append([])
        for y in range(size.y):
            image_data[x].append(image.get_pixel(x,y))
    image.unlock()
    
# warning-ignore:shadowed_variable
    var rules = {"top": [], "right": [], "bottom": [], "left": []}
    for tile in tileset.tiles:
        var texture = tile.texture
        var tile_index = tileset.get_tile_index(tile)
        for other_tile in tileset.tiles:
            var other_texture = other_tile.texture
            var other_tile_index = tileset.get_tile_index(other_tile)
            if match_left_edge_to_right_edge(texture, other_texture):
                rules.left.append([tile_index, other_tile_index])
            if match_right_edge_to_left_edge(texture, other_texture):
                rules.right.append([tile_index, other_tile_index])
            if match_top_edge_to_bottom_edge(texture, other_texture):
                rules.top.append([tile_index, other_tile_index])
            if match_bottm_edge_to_top_edge(texture, other_texture):
                rules.bottom.append([tile_index, other_tile_index])
    return rules

func match_left_edge_to_right_edge(texture1, texture2):
    var region1 = texture1.region
    var region2 = texture2.region
    
    var edge1 = []
    var x = region1.position.x
    for y in range(region1.position.y, region1.position.y + region1.size.y):
        edge1.append(image_data[x][y])
    
    var edge2 = []
    x = region2.position.x + region2.size.x - 1
    for y in range(region2.position.y, region2.position.y + region2.size.y):
        edge2.append(image_data[x][y])
    
    var count_matches = 0.0
    var size = min(edge1.size(), edge2.size())
    for i in range(size):
        if is_color_match(edge1[i], edge2[i]):
            count_matches += 1
    
    if count_matches / size > pixel_percentage_threshold:
        return true
    else:
        return false

func match_right_edge_to_left_edge(texture1, texture2):
    var region1 = texture1.region
    var region2 = texture2.region
    
    var edge1 = []
    var x = region1.position.x + region1.size.x - 1
    for y in range(region1.position.y, region1.position.y + region1.size.y):
        edge1.append(image_data[x][y])
    
    var edge2 = []
    x = region2.position.x
    for y in range(region2.position.y, region2.position.y + region2.size.y):
        edge2.append(image_data[x][y])
    
    var count_matches = 0.0
    var size = min(edge1.size(), edge2.size())
    for i in range(size):
        if is_color_match(edge1[i], edge2[i]):
            count_matches += 1
    
    if count_matches / size > pixel_percentage_threshold:
        return true
    else:
        return false

func match_top_edge_to_bottom_edge(texture1, texture2):
    var region1 = texture1.region
    var region2 = texture2.region
    
    var edge1 = []
    var y = region1.position.y
    for x in range(region1.position.x, region1.position.x + region1.size.x):
        edge1.append(image_data[x][y])
    
    var edge2 = []
    y = region2.position.y + region2.size.y - 1
    for x in range(region2.position.x, region2.position.x + region2.size.x):
        edge2.append(image_data[x][y])
    
    var count_matches = 0.0
    var size = min(edge1.size(), edge2.size())
    for i in range(size):
        if is_color_match(edge1[i], edge2[i]):
            count_matches += 1
    
    if count_matches / size > pixel_percentage_threshold:
        return true
    else:
        return false

func match_bottm_edge_to_top_edge(texture1, texture2):
    var region1 = texture1.region
    var region2 = texture2.region
    
    var edge1 = []
    var y = region1.position.y + region1.size.y - 1
    for x in range(region1.position.x, region1.position.x + region1.size.x):
        edge1.append(image_data[x][y])
    
    var edge2 = []
    y = region2.position.y
    for x in range(region2.position.x, region2.position.x + region2.size.x):
        edge2.append(image_data[x][y])
    
    var count_matches = 0.0
    var size = min(edge1.size(), edge2.size())
    for i in range(size):
        if is_color_match(edge1[i], edge2[i]):
            count_matches += 1
    
    if count_matches / size > pixel_percentage_threshold:
        return true
    else:
        return false

func can_be_neighbor(slot, direction, neighbor):
    for rule in rules[direction]:
        if rule[0] == slot:
            if rule[1] == neighbor:
                return true
    return false

func is_color_match(color1, color2):
    var v1 = Vector3(color1.r, color1.g, color1.b)
    var v2 = Vector3(color2.r, color2.g, color2.b)
    return v1.distance_to(v2) <= color_match_threshold
