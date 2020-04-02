// TODO: Only allow remove layers if > 1 exists.

public class AddDeleteLayer : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<MouseDownEvent, RemoveActiveLayerButton>())
        {
            var activeLayer = GetEntityItem1<ActiveLayer>();
            if (activeLayer && activeLayer.active)
            {
                var grid = activeLayer.active.GetComponent<GridData>();
                foreach(var cell in grid.cells)
                    cell.Destroy();
                Destroy(activeLayer.active.gameObject);
            }
        }
    }
}
