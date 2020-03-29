using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class UpdateTileSelection : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<MouseDownEvent, TilePalletteCell>())
        {
            var mouseClickEvent = entity.Item1;
            var cell = entity.Item2.gameObject;
            var tileSelection = GetEntities<TileSelection>().FirstOrDefault();
            if (tileSelection != null)
            {
                tileSelection.Item1.cell = cell;
                var spriteOfClicked = cell.GetComponent<SpriteRenderer>().sprite;
                tileSelection.Item1.spriteRenderer.sprite = spriteOfClicked;
                var imageOfClicked = cell.GetComponent<Image>().sprite;
                tileSelection.Item1.image.sprite = imageOfClicked;
            } 
        }
    }
}
