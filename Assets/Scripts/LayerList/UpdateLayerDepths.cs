using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpdateLayerDepths : ECSSystem
{
    private void Update()
    {
        var layerList = GetEntityItem1<ActiveLayer>();
        foreach (var entity in GetEntities<Layer, GridData>())
        {
            var layer = entity.Item1;
            var grid = entity.Item2;

            var expectedDepth = layerList.transform.childCount - 1 - layer.transform.GetSiblingIndex();
            if (expectedDepth != layer.depth)
            {
                layer.depth = expectedDepth;
                foreach (var cell in grid.cells)
                {
                    foreach(var instance in cell.instances)
                    foreach (var spriteRenderer in instance.GetComponents<SpriteRenderer>())
                        spriteRenderer.sortingOrder = layer.depth;
                }
            }
        }
    }
}
