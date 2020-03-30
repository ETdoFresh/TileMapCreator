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
            var mousePosition = entity.Item2.worldPosition;

            if (selectionSquare.currentCell)
            {
                var cellGameObject = selectionSquare.currentCell.instances
                    .FirstOrDefault(i => i.GetComponent<TileGridCell>());

                if (cellGameObject)
                {
                    var boundingBox = cellGameObject.GetComponent<Collider2D>();
                    if (boundingBox && boundingBox.bounds.Contains(mousePosition))
                        continue;
                    else
                        selectionSquare.currentCell = null;
                }
            }

            var tileGrid = GetEntityItem2<TileGridBackground, GridData>();
            // ReSharper disable once Unity.PerformanceCriticalCodeNullComparison
            if (tileGrid != null)
                foreach (var cell in tileGrid.cells)
                {
                    var cellGameObject = cell.instances
                        .FirstOrDefault(i => i.GetComponent<TileGridCell>());
                    
                    if (!cellGameObject) continue;

                    // ReSharper disable once Unity.PerformanceCriticalCodeInvocation
                    var boundingBox = cellGameObject.GetComponent<Collider2D>();
                    if (boundingBox && boundingBox.bounds.Contains(mousePosition))
                    {
                        selectionSquare.spriteRenderer.enabled = true;
                        selectionSquare.transform.position = cellGameObject.transform.position;
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