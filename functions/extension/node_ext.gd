class_name NodeExt

static func add_child(node, child):
    node.add_child(child)
    return node

static func replace(old_child, new_child):
    old_child.get_parent().add_child(new_child)
    old_child.get_parent().remove_child(old_child)
    return new_child

static func full_rect_layout(node):
    node.rect_size = Util.get_viewport().size
    return node
