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
                tileGridBackground.grid = UnityData.Create<GridData>();

            var grid = tileGridBackground.grid;
            RemoveOutOfRangeBackgroundCells(grid.cells, grid.size);
            AddMissingBackgroundCells(tileGridBackground);
        }

        foreach (var layer in GetEntitiesItem1<Layer>())
        foreach (var tileGrid in GetEntitiesItem1<TileGrid>())
        {
            RemoveOutOfRangeCells(layer);
            RemoveOutOfRangeCells(tileGrid);
            AddMissingCells(layer, tileGrid);
        }
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

    private void AddMissingCells(Layer layer, TileGrid tileGrid)
    {
        var grid = layer.grid;
        for (var y = 0; y < grid.size.y; y++)
        for (var x = 0; x < grid.size.x; x++)
        {
            var cell = grid.cells.FirstOrDefault(c => c.position.x == x && c.position.y == y && c.layer == layer);

            if (!cell)
                continue;

            var tileGridCell = cell.instances
                .Where(c => c.GetComponent<TileGridCell>())
                .Select(c => c.GetComponent<TileGridCell>())
                .FirstOrDefault();

            if (!tileGridCell)
            {
                var tile = Instantiate(tileGrid.emptyTilePrefab, tileGrid.transform);
                tile.name = $"Cell ({x}, {y}) ({layer.name})";
                var position = tile.transform.position;
                position.x = x + 0.5f;
                position.y = y + 0.5f;
                tile.transform.position = position;
                cell.instances.Add(tile);

                var spriteRenderer = tile.GetComponent<SpriteRenderer>();
                spriteRenderer.sortingOrder = layer.depth;
                tileGridCell = tile.GetComponent<TileGridCell>();
                tileGridCell.cell = cell;

                if (cell.sprite)
                    spriteRenderer.sprite = cell.sprite;
                else
                    cell.sprite = spriteRenderer.sprite;
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
                cells.Add(cell);
            }

            var tileGridCell = cell.instances
                .Where(c => c.GetComponent<TileGridCell>())
                .Select(c => c.GetComponent<TileGridCell>())
                .FirstOrDefault();

            if (!tileGridCell)
            {
                var tile = Instantiate(prefab, tileGridBackground.transform);
                tile.name = $"Cell ({x}, {y})";
                var position = tile.transform.position;
                position.x = x + 0.5f;
                position.y = y + 0.5f;
                tile.transform.position = position;
                cell.instances.Add(tile);

                tileGridCell = tile.GetComponent<TileGridCell>();
                tileGridCell.cell = cell;
            }
        }
    }
}