using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

// TODO: Consider adding fill function
// TODO: Consider adding selection box/drag to move

public class PaintTileGridWithTileSelection : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<MouseDownEvent, TileGridCell>())
        {
            var clickedCell = entity.Item2.cell;

            var tileSelection = GetEntityItem1<TileSelection>();
            if (tileSelection)
            {
                foreach (var entity2 in GetEntities<LayerList>())
                {
                    var activeLayer = entity2.Item1.active;
                    var cells = activeLayer.GetComponent<GridData>().cells;
                    var cell = cells.FirstOrDefault(c => c.position == clickedCell.position && c.layer == activeLayer);
                    if (cell) cell.sprite = tileSelection.spriteRenderer.sprite;
                    foreach(var instance in cell.instances)
                    {
                        var spriteRenderer = instance.GetComponent<SpriteRenderer>();
                        if (spriteRenderer) spriteRenderer.sprite = cell.sprite;
                    }
                }
            }
        }
        
        // TODO: Paint sprites while holding mouse button down
        // foreach (var entity in GetEntities<MouseEnterEvent, TileGridCell>())
        // {
        //     var cell = entity.Item2.gameObject;
        //
        //     var tileSelection = GetEntities<TileSelection>().Select(e => e.Item1).FirstOrDefault();
        //     if (tileSelection)
        //     {
        //         var cellSpriteRenderer = cell.GetComponent<SpriteRenderer>(); 
        //         cellSpriteRenderer.sprite = tileSelection.spriteRenderer.sprite;
        //     }
        // }
    }
}
