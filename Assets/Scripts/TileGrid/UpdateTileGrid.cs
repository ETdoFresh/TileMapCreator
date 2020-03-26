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
        foreach (var entity in GetEntities<TileGrid, GridData>())
        {
            var tilePrefab = entity.Item1.tilePrefab;
            var grid = entity.Item2;
            var size = grid.size;
            var cells = grid.cells;

            var cellCount = size.x * size.y;
            cellCount = Math.Max(0, cellCount);

            RemoveOutOfRangeCells(cells, size);
            AddMissingCells(size, cells, tilePrefab, grid);
        }
    }

    private static void RemoveOutOfRangeCells(List<Cell> cells, Vector2Int size)
    {
        for (var i = cells.Count - 1; i >= 0; i--)
        {
            var cell = cells[i];
            if (cell.position.x < 0 || cell.position.x >= size.x
                                    || cell.position.y < 0 || cell.position.y >= size.y)
                cells.RemoveAt(i);
        }
    }

    private void AddMissingCells(Vector2Int size, List<Cell> cells, GameObject tilePrefab, GridData grid)
    {
        var layerList = GetEntityItem1<LayerList>();
        if (!layerList) return;

        var activeLayer = layerList.active;
        if (!activeLayer) return;

        var layerGrid = activeLayer.GetComponent<GridData>();
        for (var y = 0; y < size.y; y++)
        for (var x = 0; x < size.x; x++)
        {
            var cell = cells.FirstOrDefault(c => c.position.x == x && c.position.y == y);

            if (!cell)
            {
                cell = layerGrid.cells.FirstOrDefault(c => c.position.x == x && c.position.y == y);
                if (cell) cells.Add(cell);
            }

            if (!cell)
                continue;

            var tileGridCell = cell.instances
                .Where(c => c.GetComponent<TileGridCell>())
                .Select(c => c.GetComponent<TileGridCell>())
                .FirstOrDefault();

            if (!tileGridCell)
            {
                var tile = Instantiate(tilePrefab, grid.transform);
                tile.name = $"Cell ({x}, {y})";
                var position = tile.transform.position;
                position.x = x + 0.5f;
                position.y = y + 0.5f;
                tile.transform.position = position;
                cell.instances.Add(tile);

                cell.sprite = tile.GetComponent<SpriteRenderer>().sprite;
                tileGridCell = tile.GetComponent<TileGridCell>();
                tileGridCell.cell = cell;
            }
        }
    }
}