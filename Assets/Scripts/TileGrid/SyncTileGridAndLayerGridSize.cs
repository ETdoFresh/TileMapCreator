// TODO: Sync individual tilegrid layer sizes with tilegrids.

public class SyncTileGridAndLayerGridSize : ECSSystem
{
    private void Update()
    {
        foreach (var layer in GetEntitiesItem1<Layer>())
        {
            foreach (var tileGrid in GetEntitiesItem1<TileGrid>())
                if (tileGrid.grid)
                    tileGrid.grid.size = layer.grid.size;

            foreach (var tileGridBackground in GetEntitiesItem1<TileGridBackground>())
                if (tileGridBackground.grid)
                    tileGridBackground.grid.size = layer.grid.size;
        }
    }
}