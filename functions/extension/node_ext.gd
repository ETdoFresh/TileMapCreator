class_name NodeExt

static func add_child(node, child):
    node.add_child(child)
    return node

static func remove_child(node, child):
    node.remove_child(child)
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

static func size_flag_fill_and_expand(node):
    node.size_flags_horizontal = node.SIZE_EXPAND_FILL
    node.size_flags_vertical = node.SIZE_EXPAND_FILL
    return node

static func delete_all_children(node):
    for i in range(node.get_child_count() - 1, -1, -1):
        delete(node.get_child(i))
    return node

static func delete(node):
    node.free()
    return null

static func mouse_filter_ignore(node):
    node.mouse_filter = Control.MOUSE_FILTER_IGNORE
    return node
