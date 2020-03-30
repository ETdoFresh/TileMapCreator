using System;

public class SyncTileGridAndLayerGridSize : ECSSystem
{
    private void Update()
    {
        foreach (var layerGrid in GetEntitiesItem2<Layer, GridData>())
        {
            foreach (var tileGrid in GetEntitiesItem2<TileGrid, GridData>())
                tileGrid.size = layerGrid.size;

            foreach (var tileGridBackground in GetEntitiesItem2<TileGridBackground, GridData>())
                tileGridBackground.size = layerGrid.size;
        }
    }
}