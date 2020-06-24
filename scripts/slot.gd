tool
class_name Slot
extends GridContainer

var entropy
var neighbor = { "top": null, "right": null, "bottom": null, "left": null }

func _ready():
    if not Engine.editor_hint:
        calculate_entropy()

func _process(_delta):
    for i in range(1, 20 + 1):
        if get_child_count() <= i * i:
            columns = i
            break

func calculate_entropy():
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
        for i in range(get_child_count() - 1, -1, -1):
            if get_child(i) != random_child:
                get_child(i).queue_free()

func collapse_neighbors(rules:Rules):
    var counts = \
    {
        "top": neighbor.top.get_child_count() if neighbor.top else null,
        "right": neighbor.right.get_child_count() if neighbor.right else null,
        "bottom": neighbor.bottom.get_child_count() if neighbor.bottom else null,
        "left": neighbor.left.get_child_count() if neighbor.left else null,
    }
    
    for direction in counts:
        if counts[direction]:
            rules.
