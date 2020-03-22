using System;
using UnityEditor;
using UnityEngine;

public class CheckOnGrid : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<SelectionSquare>())
        {
            var selectionSquare = entity.Item1;
            
            // Check if mouse overlaps a cell then mark onGrid = true/false
        }
    }
}
