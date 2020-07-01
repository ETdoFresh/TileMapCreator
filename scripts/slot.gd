tool
class_name Slot
extends GridContainer

var entropy
var sprites = []
var neighbors = { "top": null, "right": null, "bottom": null, "left": null }

func _ready():
    if not Engine.editor_hint:
        for child in get_children(): sprites.append(child)
        calculate_entropy()

func _process(_delta):
    if not Engine.editor_hint:
        for i in range(1, 20 + 1):
            if Util.get_visibile_child_count(self) <= i * i:
                columns = i
                break
    else:
        for i in range(1, 20 + 1):
            if get_child_count() <= i * i:
                columns = i
                break

func calculate_entropy():
    var weight = 1.0 / 16
    var total_sum_of_weights = weight * sprites.size()
    var log_2_total_sum_of_weights = log(total_sum_of_weights) / log (2)
    var sum_log_2_of_weights = 0
    for _i in range(sprites.size()):
        sum_log_2_of_weights += log(weight) / log(2)
    
    var small_random_value = randf() * 0.001
    
    entropy = log_2_total_sum_of_weights
    entropy -= sum_log_2_of_weights / total_sum_of_weights
    entropy += small_random_value

func collapse():
    if sprites.size() > 1:
        var random_index = randi() % sprites.size()
        var random_child = sprites[random_index]
        for i in range(sprites.size() - 1, -1, -1):
            if sprites[i] != random_child:
                sprites[i].queue_free()
                sprites.remove(i)

func collapse_neighbors(rules:Rules):
    for direction in neighbors:
        
        if not neighbors[direction]: continue
        
        var neighbor = neighbors[direction]
        var neighbor_needs_to_collapse_its_neighbors = false
        var neighbor_sprite_count = neighbor.sprites.size()
        if neighbor_sprite_count > 1:
            for i in range(neighbor_sprite_count - 1, -1, -1):
                var neighbor_sprite = neighbor.sprites[i]
                var neighbor_index = int(neighbor_sprite.name.replace("Sprite", ""))
                if not can_be_neighbors(rules, direction, neighbor_index):
                    neighbor_sprite.queue_free()
                    neighbor.sprites.remove(i)
                    neighbor_needs_to_collapse_its_neighbors = true
        
        if neighbor_needs_to_collapse_its_neighbors:
            neighbor.collapse_neighbors(rules)

func can_be_neighbors(rules:Rules, direction, neighbor_index):
    for sprite in sprites:
        var sprite_index = int(sprite.name.replace("Sprite", ""))
        if rules.can_be_neighbor(sprite_index, direction, neighbor_index):
            return true
    return false
