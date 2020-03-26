using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class PaintTileGridWithTileSelection : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<MouseDownEvent, TileGridCell>())
        {
            var cell = entity.Item2.gameObject;

            var tileSelection = GetEntities<TileSelection>().Select(e => e.Item1).FirstOrDefault();
            if (tileSelection)
            {
                // TODO: Set sprite of Layer Cell to Selected Tile
                // foreach (var entity2 in GetEntities<LayerList>())
                // {
                //     var activeLayer = entity2.Item1.active;
                //     var cells = activeLayer.GetComponent<GridData>().cells;
                // }
                
                var cellSpriteRenderer = cell.GetComponent<SpriteRenderer>(); 
                cellSpriteRenderer.sprite = tileSelection.spriteRenderer.sprite;
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
