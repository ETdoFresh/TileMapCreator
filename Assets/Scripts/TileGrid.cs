using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class TileGrid : ECSComponent
{
    public GameObject tilePrefab;
    public Vector2Int size;
    public List<GameObject> cells = new List<GameObject>();
}