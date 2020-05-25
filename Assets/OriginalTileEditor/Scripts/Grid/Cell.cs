using System;
using System.Collections.Generic;
using UnityEngine;

public class Cell : UnityData
{
    public Layer layer;
    public GridData grid;
    public Vector2Int position;
    public Sprite sprite;
    public TileGridCell tileGridCell;

    protected override void OnDestroy()
    {
        if (tileGridCell)
            Destroy(tileGridCell.gameObject);
    }
}