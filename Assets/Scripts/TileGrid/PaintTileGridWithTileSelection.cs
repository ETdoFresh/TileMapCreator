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
                var cellSpriteRenderer = cell.GetComponent<SpriteRenderer>(); 
                cellSpriteRenderer.sprite = tileSelection.spriteRenderer.sprite;
            }
        }
        
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
