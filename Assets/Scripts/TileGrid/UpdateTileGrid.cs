using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UpdateTileGrid : ECSSystem
{
    private List<GameObject> entities = new List<GameObject>();
    
    private void Update()
    {
        foreach (var entity in GetEntities<TileGrid>())
        {
            var tileGrid = entity.Item1;
            var tilePrefab = tileGrid.tilePrefab;
            var size = tileGrid.size;
            var cells = tileGrid.cells;

            var cellCount = size.x * size.y;
            cellCount = Math.Max(0, cellCount);
            
            var hasChanged = false;
            while (cellCount > cells.Count)
            {
                hasChanged = true;
                var cell = Instantiate(tilePrefab, tileGrid.transform);
                cells.Add(cell);
            }

            while (cellCount < cells.Count)
            {
                hasChanged = true;
                var cell = cells[cells.Count - 1];
                Destroy(cell);
                cells.Remove(cell);
            }

            if (hasChanged)
            {
                for (var y = 0; y < size.y; y++)
                for (var x = 0; x < size.x; x++)
                {
                    var cell = cells[x + y * size.x].transform;
                    cell.name = $"Cell ({x}, {y})";
                    var position = cell.position;
                    position.x = x + 0.5f;
                    position.y = y + 0.5f;
                    cell.position = position;
                }
            }
        }
    }
}