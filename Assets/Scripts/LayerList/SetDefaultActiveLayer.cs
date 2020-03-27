using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetDefaultActiveLayer : ECSSystem
{
    void Update()
    {
        foreach (var entity in GetEntities<LayerList>())
        {
            var layerList = entity.Item1;
            if (layerList.active) continue;
         
            var layers = layerList.layers;
            if (layers.Count > 0)
            {
                layerList.active = layers[0];
                layerList.active.isActive = true;
            }
        }
    }
}
