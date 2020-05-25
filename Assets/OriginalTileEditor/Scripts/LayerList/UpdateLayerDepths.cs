using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpdateLayerDepths : ECSSystem
{
    private void Update()
    {
        var layerList = GetEntityItem1<ActiveLayer>();
        foreach (var layer in GetEntitiesItem1<Layer>())
        {
            var expectedDepth = layerList.transform.childCount - 1 - layer.transform.GetSiblingIndex();
            if (expectedDepth != layer.depth)
                layer.depth = expectedDepth;
        }
    }
}
