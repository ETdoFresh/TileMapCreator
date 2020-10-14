class_name EdgeDetection

const PIXEL_PERCENTAGE_THRESHOLD = 0.75
const COLOR_MATCH_THRESHOLD = 0.1

static func get_image_data(tileset):
    var atlasTexture = tileset.tiles[0].texture
    var image = atlasTexture.atlas.get_data()
    image.lock()
    var size = image.get_size()
    var image_data = []
    for x in range(size.x):
        image_data.append([])
        for y in range(size.y):
            image_data[x].append(image.get_pixel(x,y))
    image.unlock()
    return image_data

static func match_edges(rules, tileset):
    var image_data = get_image_data(tileset)
    for tile in tileset.tiles:
        var texture = tile.texture
        var tile_id = Tileset.get_id(tileset, tile)
        for other_tile in tileset.tiles:
            var other_texture = other_tile.texture
            var other_tile_id = Tileset.get_id(tileset, other_tile)
            if match_left_edge_to_right_edge(texture, other_texture, image_data):
                rules.left.append([tile_id, other_tile_id])
            if match_right_edge_to_left_edge(texture, other_texture, image_data):
                rules.right.append([tile_id, other_tile_id])
            if match_top_edge_to_bottom_edge(texture, other_texture, image_data):
                rules.top.append([tile_id, other_tile_id])
            if match_bottm_edge_to_top_edge(texture, other_texture, image_data):
                rules.bottom.append([tile_id, other_tile_id])
    return rules

static func match_edges_coroutine(rules, tileset):
    var start_time = OS.get_ticks_msec()
    var image_data = get_image_data(tileset)
    for tile in tileset.tiles:
        var texture = tile.texture
        var tile_id = Tileset.get_id(tileset, tile)
        for other_tile in tileset.tiles:
            var current_time = OS.get_ticks_msec()
            if current_time - start_time > WaveFunctionCollapse.YIELD_TIME:
                if not yield():
                    return rules
                start_time = OS.get_ticks_msec()
            var other_texture = other_tile.texture
            var other_tile_id = Tileset.get_id(tileset, other_tile)
            if match_left_edge_to_right_edge(texture, other_texture, image_data):
                rules.left.append([tile_id, other_tile_id])
            if match_right_edge_to_left_edge(texture, other_texture, image_data):
                rules.right.append([tile_id, other_tile_id])
            if match_top_edge_to_bottom_edge(texture, other_texture, image_data):
                rules.top.append([tile_id, other_tile_id])
            if match_bottm_edge_to_top_edge(texture, other_texture, image_data):
                rules.bottom.append([tile_id, other_tile_id])
    return rules

static func match_left_edge_to_right_edge(texture1, texture2, image_data):
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
    
    if count_matches / size > PIXEL_PERCENTAGE_THRESHOLD:
        return true
    else:
        return false

static func match_right_edge_to_left_edge(texture1, texture2, image_data):
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
    
    if count_matches / size > PIXEL_PERCENTAGE_THRESHOLD:
        return true
    else:
        return false

static func match_top_edge_to_bottom_edge(texture1, texture2, image_data):
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
    
    if count_matches / size > PIXEL_PERCENTAGE_THRESHOLD:
        return true
    else:
        return false

static func match_bottm_edge_to_top_edge(texture1, texture2, image_data):
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
    
    if count_matches / size > PIXEL_PERCENTAGE_THRESHOLD:
        return true
    else:
        return false

static func is_color_match(color1, color2):
    var v1 = Vector3(color1.r, color1.g, color1.b)
    var v2 = Vector3(color2.r, color2.g, color2.b)
    return v1.distance_to(v2) <= COLOR_MATCH_THRESHOLD
