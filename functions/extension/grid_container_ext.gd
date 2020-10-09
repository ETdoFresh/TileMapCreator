class_name GridContainerExt

static func square_off(grid_container: GridContainer):
    var child_count = grid_container.get_child_count()
    grid_container.columns = int(max(round(sqrt(child_count)), 1))
    return grid_container

static func set_spacing(grid_container: GridContainer, spacing):
    grid_container.set("custom_constants/hseparation", spacing)
    grid_container.set("custom_constants/vseparation", spacing)
    return grid_container
