// TODO: Only allow remove layers if > 1 exists.

using System.Collections.Generic;
using System.Linq;

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

        var prefabs = GetEntityItem1<Prefabs>();
        foreach (var entity in GetEntities<MouseDownEvent, AddLayerButton>())
        {
            var activeLayer = GetEntityItem1<ActiveLayer>();
            if (activeLayer)
            {
                var newLayer = Instantiate(
                    prefabs.Get("Layer"), 
                    activeLayer.transform);

                activeLayer.active = newLayer.GetComponent<Layer>();

                var layers = GetEntitiesItem1<Layer>();
                var count = layers.Count();
                for (int i = 1; i <= count; i++)
                {
                    var newName = $"Layer {i}";
                    if (NameNotTake(newName, layers))
                    {
                        newLayer.name = newName;
                        break;
                    }
                }
            }
        }
    }

    private bool NameNotTake(string newName, IEnumerable<Layer> layers)
    {
        foreach(var layer in layers)
            if (layer.name == newName)
                return false;
        return true;
    }
}
