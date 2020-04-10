using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class UpdateLayerCells : ECSSystem
{
    private void Update()
    {
        foreach (var layer in GetEntitiesItem1<Layer>())
        {
            var cells = layer.grid.cells;
            var size = layer.grid.size;
            if (size.x > 0 && size.y > 0)
            {
                if (HaveChanged(size, cells))
                {
                    RemoveExtraTiles(size, cells);
                    CreateMissingTiles(layer, size, cells);
                }
            }
            else
                for (int i = cells.Count - 1; i >= 0; i--)
                {
                    Destroy(cells[i]);
                    cells.RemoveAt(i);
                }
        }
    }

    private static bool HaveChanged(Vector2Int size, List<Cell> cells)
    {
        if (cells.Count != size.x * size.y)
            return true;
        
        for (var y = 0; y < size.y; y++)
        for (var x = 0; x < size.x; x++)
        {
            var cell = cells[x + y * size.x];
            if (cell.position.x != x || cell.position.y != y)
                return true;
        }

        return false;
    }

    private static void CreateMissingTiles(Layer layer, Vector2Int size, List<Cell> cells)
    {
        for (var y = 0; y < size.y; y++)
        for (var x = 0; x < size.x; x++)
        {
            if (!cells.Any(c => c.position.x == x && c.position.y == y))
            {
                var cell = UnityData.Create<Cell>();
                cell.layer = layer;
                cell.grid = layer.grid;
                cell.position.x = x;
                cell.position.y = y;
                cell.name = $"Cell {x}, {y} {layer.name}";
                cells.Add(cell);
            }
        }
    }

    private static void RemoveExtraTiles(Vector2Int size, List<Cell> cells)
    {
        for (int i = cells.Count - 1; i >= 0; i--)
        {
            var cell = cells[i];
            if (cell.position.x < 0
                || cell.position.x >= size.x
                || cell.position.y < 0
                || cell.position.y >= size.y
                || cell.layer == null)
            {
                cell.Destroy();
                cells.RemoveAt(i);
            }
        }
    }
}