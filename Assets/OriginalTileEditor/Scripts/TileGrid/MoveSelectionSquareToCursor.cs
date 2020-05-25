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
                var tileGridCell = selectionSquare.currentCell.tileGridCell;
                if (tileGridCell)
                {
                    var boundingBox = tileGridCell.GetComponent<Collider2D>();
                    if (boundingBox && boundingBox.bounds.Contains(mousePosition))
                        continue;
                    else
                        selectionSquare.currentCell = null;
                }
            }

            var tileGridBackground = GetEntityItem1<TileGridBackground>();
            if (tileGridBackground && tileGridBackground.grid)
                foreach (var cell in tileGridBackground.grid.cells)
                {
                    if (!cell.tileGridCell) continue;

                    var boundingBox = cell.tileGridCell.GetComponent<Collider2D>();
                    if (boundingBox && boundingBox.bounds.Contains(mousePosition))
                    {
                        selectionSquare.spriteRenderer.enabled = true;
                        selectionSquare.transform.position = cell.tileGridCell.transform.position;
                        selectionSquare.currentCell = cell;
                        break;
                    }
                }
            
            if (selectionSquare.currentCell == null)
                selectionSquare.spriteRenderer.enabled = false;
        }
    }
}