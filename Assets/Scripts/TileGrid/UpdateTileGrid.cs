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
        foreach (var entity in GetEntities<TileGridBackground, GridData>())
        {
            var cellPrefab = entity.Item1.cellPrefab;
            var grid = entity.Item2;
            RemoveOutOfRangeBackgroundCells(grid.cells, grid.size);
            AddMissingBackgroundCells(grid.size, grid.cells, cellPrefab, grid);
        }

        foreach (var entity in GetEntities<TileGrid, GridData>())
        {
            var tilePrefab = entity.Item1.tilePrefab;
            var grid = entity.Item2;
            RemoveOutOfRangeCells(grid.cells, grid.size);
            AddMissingCells(grid.size, grid.cells, tilePrefab, grid);
        }
    }

    private void RemoveOutOfRangeCells(List<Cell> cells, Vector2Int size)
    {
        var layers = GetEntities<Layer>().Select(e => e.Item1);

        for (var i = cells.Count - 1; i >= 0; i--)
        {
            var cell = cells[i];
            if (cell.position.x < 0
                || cell.position.x >= size.x
                || cell.position.y < 0
                || cell.position.y >= size.y
                || !layers.Contains(cell.layer))
            {
                for (var j = cell.instances.Count - 1; j >= 0; j--)
                {
                    var tileGridCell = cell.instances[j].GetComponent<TileGridCell>();
                    if (tileGridCell)
                    {
                        Destroy(tileGridCell.gameObject);
                        cell.instances.RemoveAt(j);
                    }
                }

                cells.RemoveAt(i);
            }
        }
    }

    private void AddMissingCells(Vector2Int size, List<Cell> cells, GameObject tilePrefab, GridData grid)
    {
        var layerList = GetEntityItem1<LayerList>();
        if (!layerList) return;

        foreach (var entity in GetEntities<Layer, GridData>())
        {
            var layer = entity.Item1;
            var layerGrid = entity.Item2;
            for (var y = 0; y < size.y; y++)
            for (var x = 0; x < size.x; x++)
            {
                var cell = cells.FirstOrDefault(c => c.position.x == x && c.position.y == y && c.layer == layer);

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
    }
    
    private void RemoveOutOfRangeBackgroundCells(List<Cell> cells, Vector2Int size)
    {
        for (var i = cells.Count - 1; i >= 0; i--)
        {
            var cell = cells[i];
            if (cell.position.x < 0
                || cell.position.x >= size.x
                || cell.position.y < 0
                || cell.position.y >= size.y)
            {
                for (var j = cell.instances.Count - 1; j >= 0; j--)
                {
                    var tileGridCell = cell.instances[j].GetComponent<TileGridCell>();
                    if (tileGridCell)
                    {
                        Destroy(tileGridCell.gameObject);
                        cell.instances.RemoveAt(j);
                    }
                }

                cells.RemoveAt(i);
            }
        }
    }

    private void AddMissingBackgroundCells(Vector2Int size, List<Cell> cells, GameObject prefab, GridData grid)
    {
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
                var tile = Instantiate(prefab, grid.transform);
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