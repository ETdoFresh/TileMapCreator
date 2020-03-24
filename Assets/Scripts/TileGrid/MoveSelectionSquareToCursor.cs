using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class MoveSelectionSquareToCursor : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<SelectionSquare, MousePosition, TileGridSelection>())
        {
            var selectionSquare = entity.Item1;
            var mousePosition = entity.Item2.position;

            if (selectionSquare.currentCell)
            {
                // ReSharper disable once Unity.PerformanceCriticalCodeInvocation
                var boundingBox = selectionSquare.currentCell.GetComponent<Collider2D>();
                if (boundingBox.bounds.Contains(mousePosition))
                    continue;
                else
                    selectionSquare.currentCell = null;
            }

            var tileGrid = GetEntities<TileGrid>().Select(t => t.Item1).FirstOrDefault();
            // ReSharper disable once Unity.PerformanceCriticalCodeNullComparison
            if (tileGrid != null)
                foreach (var cell in tileGrid.cells)
                {
                    // ReSharper disable once Unity.PerformanceCriticalCodeInvocation
                    var boundingBox = cell.GetComponent<Collider2D>();
                    if (boundingBox.bounds.Contains(mousePosition))
                    {
                        selectionSquare.spriteRenderer.enabled = true;
                        selectionSquare.transform.position = cell.transform.position;
                        selectionSquare.currentCell = cell;
                        break;
                    }
                }

            // ReSharper disable once Unity.PerformanceCriticalCodeNullComparison
            if (selectionSquare.currentCell == null)
                selectionSquare.spriteRenderer.enabled = false;
        }
    }
}