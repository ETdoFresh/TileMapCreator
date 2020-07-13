tool
class_name Slot
extends GridContainer

var entropy
var neighbors = { "top": null, "right": null, "bottom": null, "left": null }

func _ready():
    if not Engine.editor_hint:
        calculate_entropy()

func _process(_delta):
    if not Engine.editor_hint:
        columns = int(max(round(sqrt(Util.get_visibile_child_count(self))), 1))
    else:
        columns = int(max(round(sqrt(get_child_count())), 1))

func calculate_entropy():
    if get_child_count() == 0:
        return
        
    var weight = 1.0 / 16
    var total_sum_of_weights = weight * get_child_count()
    var log_2_total_sum_of_weights = log(total_sum_of_weights) / log (2)
    var sum_log_2_of_weights = 0
    for _i in range(get_child_count()):
        sum_log_2_of_weights += log(weight) / log(2)
    
    var small_random_value = randf() * 0.001
    
    entropy = log_2_total_sum_of_weights
    entropy -= sum_log_2_of_weights / total_sum_of_weights
    entropy += small_random_value

func collapse():
    if get_child_count() > 1:
        var random_index = randi() % get_child_count()
        var random_child = get_child(random_index)
        for child in get_children():
            if child != random_child:
                child.queue_free()

func collapse_neighbors(rules):
    for direction in neighbors:
        
        if not neighbors[direction]: continue
        
        var neighbor = neighbors[direction]
        var neighbor_needs_to_collapse_its_neighbors = false
        var neighbor_sprite_count = neighbor.get_child_count()
        if neighbor_sprite_count > 1:
            for i in range(neighbor_sprite_count - 1, -1, -1):
                var neighbor_sprite = neighbor.get_child(i)
                var neighbor_index = int(neighbor_sprite.name.replace("Sprite", ""))
                if not can_be_neighbors(rules, direction, neighbor_index):
                    neighbor_sprite.queue_free()
                    neighbor_needs_to_collapse_its_neighbors = true
        
        if neighbor_needs_to_collapse_its_neighbors:
            neighbor.collapse_neighbors(rules)

func can_be_neighbors(rules, direction, neighbor_index):
    for sprite in get_children():
        var sprite_index = int(sprite.name.replace("Sprite", ""))
        if rules.can_be_neighbor(sprite_index, direction, neighbor_index):
            return true
    return false
