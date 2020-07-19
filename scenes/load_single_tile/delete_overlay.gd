extends GridContainer

func _process(_delta):
    if not visible:
        return
    
    columns = int(max(round(sqrt(get_child_count())), 1))
