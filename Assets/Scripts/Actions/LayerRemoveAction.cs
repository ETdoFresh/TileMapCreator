public class LayerRemoveAction : Action
{
    public ActiveLayer activeLayer;
    public Layer layer;
    public GridData grid;

    public override void Perform()
    {
        if (layer == null) layer = activeLayer.active;
        grid = layer.GetComponent<GridData>();
        layer.gameObject.SetActive(false);
    }

    public override void Revert()
    {
        layer.gameObject.SetActive(true);
    }

    protected override void OnDestroy()
    {
        base.OnDestroy();
        foreach (var cell in grid.cells)
            cell.Destroy();
        Destroy(layer.gameObject);
    }
}