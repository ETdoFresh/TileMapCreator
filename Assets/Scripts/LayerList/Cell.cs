using System;
using System.Collections.Generic;
using UnityEngine;

public class Cell : UnityData
{
    public Layer layer;
    public Vector2Int position;
    public Sprite sprite;
    public List<GameObject> instances = new List<GameObject>();

    protected override void OnDestroy()
    {
        foreach(var instance in instances)
            Destroy(instance);
        instances.Clear();
    }
}