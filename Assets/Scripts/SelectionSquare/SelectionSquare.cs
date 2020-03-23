using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SelectionSquare : ECSComponent
{
    public bool isMouseOnCanvas;
    public bool isMouseOnGrid;
    public SpriteRenderer spriteRenderer;
    public Vector2Int position;
    public GameObject currentCell;
}
