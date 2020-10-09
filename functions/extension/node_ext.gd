class_name NodeExt

static func add_child(node, child):
    node.add_child(child)
    return node

static func replace(old_child, new_child):
    var index = old_child.get_index()
    old_child.get_parent().add_child(new_child)
    old_child.get_parent().remove_child(old_child)
    new_child.get_parent().move_child(new_child, index)
    return new_child

static func full_rect_layout(node):
    node.rect_size = Util.project_resolution
    return node

static func delete_all_children(node):
    for i in range(node.get_child_count() - 1, -1, -1):
        delete(node.get_child(i))

static func delete(node):
    node.free()
