using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class UpdateTileGrid : ECSSystem
{
    private List<GameObject> entities = new List<GameObject>();

    private void Update()
    {
        foreach (var tileGridBackground in GetEntitiesItem1<TileGridBackground>())
        {
            var cellPrefab = tileGridBackground.cellPrefab;

            if (!tileGridBackground.grid)
            {
                tileGridBackground.grid = UnityData.Create<GridData>();
                tileGridBackground.grid.name = "Grid (Background)";
            }

            var grid = tileGridBackground.grid;
            RemoveOutOfRangeBackgroundCells(grid.cells, grid.size);
            AddMissingBackgroundCells(tileGridBackground);
        }

        foreach (var layer in GetEntitiesItem1<Layer>())
            RemoveOutOfRangeCells(layer);
        
        foreach (var tileGrid in GetEntitiesItem1<TileGrid>())
            RemoveOutOfRangeCells(tileGrid);
        
        foreach (var tileGrid in GetEntitiesItem1<TileGrid>())
            AddMissingCells(tileGrid);
    }

    private void RemoveOutOfRangeCells(TileGrid tileGrid)
    {
        for(var i = tileGrid.transform.childCount - 1; i >= 0; i--)
        {
            var child = tileGrid.transform.GetChild(i);
            var tileGridCell = child.GetComponent<TileGridCell>();
            if (!tileGridCell || !tileGridCell.cell || !tileGridCell.cell.layer || !tileGridCell.cell.layer.enabled)
                Destroy(child.gameObject);
        }
    }

    private void RemoveOutOfRangeCells(Layer layer)
    {
        foreach (var cell in layer.grid.cells)
            if (cell.position.x < 0
                || cell.position.x >= layer.grid.size.x
                || cell.position.y < 0
                || cell.position.y >= layer.grid.size.y)
            {
                cell.Destroy();
                layer.grid.cells.Remove(cell);
            }
    }

    private void AddMissingCells(TileGrid tileGrid)
    {
        var layer = tileGrid.layer;
        var grid = layer.grid;
        for (var y = 0; y < grid.size.y; y++)
        for (var x = 0; x < grid.size.x; x++)
        {
            var cell = grid.cells.FirstOrDefault(c => c.position.x == x && c.position.y == y && c.layer == layer);

            if (!cell)
                continue;

            var tileGridCell = cell.tileGridCell;
            if (!tileGridCell)
            {
                var tile = Instantiate(tileGrid.emptyTilePrefab, tileGrid.transform);
                tileGridCell = cell.tileGridCell = tile.GetComponent<TileGridCell>();
                tile.name = $"Cell ({x}, {y}) ({layer.name})";
                var position = tile.transform.position;
                position.x = x + 0.5f;
                position.y = y + 0.5f;
                tile.transform.position = position;

                tileGridCell.spriteRenderer = tile.GetComponent<SpriteRenderer>();
                tileGridCell.spriteRenderer.sortingOrder = layer.depth;
                tileGridCell = tile.GetComponent<TileGridCell>();
                tileGridCell.cell = cell;
            }
        }
    }

    private void RemoveOutOfRangeBackgroundCells(List<Cell> cells, Vector2Int size)
    {
        for (var i = cells.Count - 1; i >= 0; i--)
        {
            var cell = cells[i];
            var cellIsOutsideGrid = cell.position.x < 0
                                    || cell.position.x >= size.x
                                    || cell.position.y < 0
                                    || cell.position.y >= size.y;
            if (cellIsOutsideGrid)
            {
                cell.Destroy();
                cells.RemoveAt(i);
            }
        }
    }

    private void AddMissingBackgroundCells(TileGridBackground tileGridBackground)
    {
        var size = tileGridBackground.grid.size;
        var cells = tileGridBackground.grid.cells;
        var prefab = tileGridBackground.cellPrefab;
        for (var y = 0; y < size.y; y++)
        for (var x = 0; x < size.x; x++)
        {
            var cell = cells.FirstOrDefault(c => c.position.x == x && c.position.y == y);
            if (!cell)
            {
                cell = UnityData.Create<Cell>();
                cell.position.x = x;
                cell.position.y = y;
                cell.name = $"Cell ({x}, {y}) (Background)";
                cell.grid = tileGridBackground.grid;
                cells.Add(cell);
            }
            
            if (!cell.tileGridCell)
            {
                var tile = Instantiate(prefab, tileGridBackground.transform);
                cell.tileGridCell = tile.GetComponent<TileGridCell>();
                cell.tileGridCell.spriteRenderer = tile.GetComponent<SpriteRenderer>();
                cell.tileGridCell.cell = cell;
                cell.sprite = cell.tileGridCell.spriteRenderer.sprite;
                tile.name = $"Cell ({x}, {y}) (Background)";
                var position = tile.transform.position;
                position.x = x + 0.5f;
                position.y = y + 0.5f;
                tile.transform.position = position;
            }
        }
    }
}