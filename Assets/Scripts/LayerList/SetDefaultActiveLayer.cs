using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetDefaultActiveLayer : ECSSystem
{
    void Update()
    {
        foreach (var activeLayer in GetEntitiesItem1<ActiveLayer>())
        {
            if (activeLayer.active && activeLayer.active.enabled) continue;

            activeLayer.active = null;
            foreach (var layer in GetEntitiesItem1<Layer>())
            {
                activeLayer.active = layer;
                SelectionChangeListener.CreateEvent(layer);
                break;
            }
        }
    }
}
