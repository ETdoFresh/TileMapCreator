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

onready var tiles = get_parent().get_node("Tileset")

func _ready():
    for sprite in tiles.get_children():
        var texture = sprite.texture
        var sprite_index = int(sprite.name.replace("Sprite",""))
        for other_sprite in tiles.get_children():
            var other_texture = other_sprite.texture
            var other_sprite_index = int(other_sprite.name.replace("Sprite",""))
            if match_left_edge_to_right_edge(texture, other_texture):
                rules.left.append([sprite_index, other_sprite_index])
            if match_right_edge_to_left_edge(texture, other_texture):
                rules.right.append([sprite_index, other_sprite_index])
            if match_top_edge_to_bottom_edge(texture, other_texture):
                rules.top.append([sprite_index, other_sprite_index])
            if match_bottm_edge_to_top_edge(texture, other_texture):
                rules.bottom.append([sprite_index, other_sprite_index])

func match_left_edge_to_right_edge(texture1, texture2):
    var region1 = texture1.region
    var region2 = texture2.region
    var image = texture1.atlas.get_data()
    
    image.lock()
    
    var edge1 = []
    var x = region1.position.x
    for y in range(region1.position.y, region1.position.y + region1.size.y):
        edge1.append(image.get_pixel(x, y))
    
    var edge2 = []
    x = region2.position.x + region2.size.x - 1
    for y in range(region2.position.y, region2.position.y + region2.size.y):
        edge2.append(image.get_pixel(x, y))
    
    image.unlock()
    
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
    var image = texture1.atlas.get_data()
    
    image.lock()
    
    var edge1 = []
    var x = region1.position.x + region1.size.x - 1
    for y in range(region1.position.y, region1.position.y + region1.size.y):
        edge1.append(image.get_pixel(x, y))
    
    var edge2 = []
    x = region2.position.x
    for y in range(region2.position.y, region2.position.y + region2.size.y):
        edge2.append(image.get_pixel(x, y))
    
    image.unlock()
    
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
    var image = texture1.atlas.get_data()
    
    image.lock()
    
    var edge1 = []
    var y = region1.position.y
    for x in range(region1.position.x, region1.position.x + region1.size.x):
        edge1.append(image.get_pixel(x, y))
    
    var edge2 = []
    y = region2.position.y + region2.size.y - 1
    for x in range(region2.position.x, region2.position.x + region2.size.x):
        edge2.append(image.get_pixel(x, y))
    
    image.unlock()
    
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
    var image = texture1.atlas.get_data()
    
    image.lock()
    
    var edge1 = []
    var y = region1.position.y + region1.size.y - 1
    for x in range(region1.position.x, region1.position.x + region1.size.x):
        edge1.append(image.get_pixel(x, y))
    
    var edge2 = []
    y = region2.position.y
    for x in range(region2.position.x, region2.position.x + region2.size.x):
        edge2.append(image.get_pixel(x, y))
    
    image.unlock()
    
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
