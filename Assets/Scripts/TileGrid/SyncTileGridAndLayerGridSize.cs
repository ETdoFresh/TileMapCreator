using System;

public class SyncTileGridAndLayerGridSize : ECSSystem
{
    private void Update()
    {
        foreach (var entity1 in GetEntities<TileGrid, GridData>())
        {
            var tileGrid = entity1.Item2;
            foreach (var entity2 in GetEntities<Layer, GridData>())
            {
                var layerGrid = entity2.Item2;
                tileGrid.size = layerGrid.size;
            }
        }
    }
}