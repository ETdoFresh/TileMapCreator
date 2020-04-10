using UnityEngine;

public class SyncTileGridsWithLayers : ECSSystem
{
    private void Update()
    {
        RemoveInactiveTileGridLayers();
        AddNewTileGridLayers();
        SyncTileGridCellsWithCells();
    }

    private void RemoveInactiveTileGridLayers()
    {
        foreach (var tileGrid in GetEntitiesItem1<TileGrid>())
        {
            var isLayerInactive = !tileGrid.layer
                                  || !tileGrid.layer.enabled
                                  || !tileGrid.layer.gameObject.activeSelf;

            if (isLayerInactive)
                Destroy(tileGrid.gameObject);
        }
    }

    private void AddNewTileGridLayers()
    {
        foreach (var layer in GetEntitiesItem1<Layer>())
        {
            var isTileGridFound = false;
            foreach (var tileGrid in GetEntitiesItem1<TileGrid>())
                if (tileGrid.layer == layer)
                {
                    isTileGridFound = true;
                    break;
                }

            if (!isTileGridFound)
            {
                var tileGrids = GetEntityItem1<TileGrids>();
                var newGameObject = new GameObject($"TileGrid_{layer.name}");
                newGameObject.transform.SetParent(tileGrids.transform);
                var tileGrid = newGameObject.AddComponent<TileGrid>();
                tileGrid.layer = layer;
                tileGrid.emptyTilePrefab = tileGrids.emptyTilePrefab;
                layer.tileGrid = tileGrid;
            }
        }
    }

    private void SyncTileGridCellsWithCells()
    {
        foreach (var tileGridCell in GetEntitiesItem1<TileGridCell>())
        {
            if (tileGridCell.spriteRenderer.sprite != tileGridCell.cell.sprite)
                tileGridCell.spriteRenderer.sprite = tileGridCell.cell.sprite;

            if (tileGridCell.cell.layer)
                if (tileGridCell.spriteRenderer.sortingOrder != tileGridCell.cell.layer.depth)
                    tileGridCell.spriteRenderer.sortingOrder = tileGridCell.cell.layer.depth;
        }
    }
}