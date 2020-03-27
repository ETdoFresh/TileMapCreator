using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpdateLayerDepths : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<Layer>())
        {
            var layer = entity.Item1;
            layer.depth = layer.transform.GetSiblingIndex();
        }
    }
}
