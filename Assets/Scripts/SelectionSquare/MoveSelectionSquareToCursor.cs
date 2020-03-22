using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveSelectionSquareToCursor : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<SelectionSquare>())
        {
            var selectionSquare = entity.Item1;
            
            // Check if mouse overlaps existing cell then do nothing
            // Check if mouse overlaps a new cell then move selection square to new cell
            // Check if mouse does not overlap grid then do nothing
        }
    }
}
