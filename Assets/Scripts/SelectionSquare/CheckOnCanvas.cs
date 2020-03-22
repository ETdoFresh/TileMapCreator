using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckOnCanvas : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<SelectionSquare>())
        {
            var selectionSquare = entity.Item1;
            
            // Check if mouse overlaps invisible canvas obj then mark onCanvas = true/false
        }
    }
}
