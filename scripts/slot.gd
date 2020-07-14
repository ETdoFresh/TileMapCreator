tool
class_name Slot
extends GridContainer

var entropy
var neighbors = { "top": null, "right": null, "bottom": null, "left": null }

var all = []
var enabled = []

func _ready():
    if not Engine.editor_hint:
        calculate_entropy()

func _process(_delta):
    if not Engine.editor_hint:
        columns = int(max(round(sqrt(enabled.size())), 1))
    else:
        columns = int(max(round(sqrt(get_child_count())), 1))
    
    for child in get_children():
        if not all.has(child):
            all.append(child)
            enabled.append(child)
            calculate_entropy()
    
    for i in range(all.size() - 1, -1, -1):
        if not get_children().has(all[i]):
            all.remove(i)
    
    for child in get_children():
        child.visible = enabled.has(child)

func reset():
    enabled.clear()
    enabled = get_children()

func calculate_entropy():
    if enabled.size() == 0:
        return
        
    var weight = 1.0 / 16
    var total_sum_of_weights = weight * enabled.size()
    var log_2_total_sum_of_weights = log(total_sum_of_weights) / log (2)
    var sum_log_2_of_weights = 0
    for _i in range(enabled.size()):
        sum_log_2_of_weights += log(weight) / log(2)
    
    var small_random_value = randf() * 0.001
    
    entropy = log_2_total_sum_of_weights
    entropy -= sum_log_2_of_weights / total_sum_of_weights
    entropy += small_random_value

func collapse():
    if enabled.size() > 1:
        var random_index = randi() % enabled.size()
        for i in range(enabled.size() - 1, -1, -1):
            if i != random_index:
                enabled.remove(i)
        add_constant_override("hseparation", 0)
        add_constant_override("vseparation", 0)
        calculate_entropy()

func collapse_neighbors(rules):
    for direction in neighbors:
        
        if not neighbors[direction]: continue
        
        var neighbor = neighbors[direction]
        var neighbor_needs_to_collapse_its_neighbors = false
        var neighbor_sprite_count = neighbor.enabled.size()
        if neighbor_sprite_count > 1:
            for i in range(neighbor_sprite_count - 1, -1, -1):
                var neighbor_sprite = neighbor.enabled[i]
                var neighbor_index = neighbor_sprite.texture.get_meta("index")
                if not can_be_neighbors(rules, direction, neighbor_index):
                    neighbor.enabled.remove(i)
                    neighbor_needs_to_collapse_its_neighbors = true
                    if neighbor.enabled.size() == 1:
                        neighbor.add_constant_override("hseparation", 0)
                        neighbor.add_constant_override("vseparation", 0)
        
        if neighbor_needs_to_collapse_its_neighbors:
            neighbor.calculate_entropy()
            neighbor.collapse_neighbors(rules)

func can_be_neighbors(rules, direction, neighbor_index):
    for sprite in enabled:
        var sprite_index = int(sprite.texture.get_meta("index"))
        if rules.can_be_neighbor(sprite_index, direction, neighbor_index):
            return true
    return false
