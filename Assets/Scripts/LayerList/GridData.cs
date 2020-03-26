using System.Collections.Generic;
using UnityEngine;

public class GridData : ECSComponent
{
    public Vector2Int size;
    public List<Cell> cells = new List<Cell>();
}