class_name GridContainerExt

static func square_off(grid_container: GridContainer):
    var child_count = grid_container.get_child_count()
    grid_container.columns = int(max(round(sqrt(child_count)), 1))
    return grid_container
