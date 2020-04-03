using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeLayerOrder : ECSSystem
{
    private void Update()
    {
        foreach (var mouseEvent in GetEntitiesItem1<MouseDownEvent, MoveActiveLayerUpButton>())
        {
            var layerList = GetEntityItem1<ActiveLayer>();
            var activeLayer = layerList.active;

            var siblingIndex = activeLayer.transform.GetSiblingIndex();
            if (activeLayer &&  siblingIndex > 0)
                activeLayer.transform.SetSiblingIndex(siblingIndex - 1);
        }
        
        foreach (var mouseEvent in GetEntitiesItem1<MouseDownEvent, MoveActiveLayerDownButton>())
        {
            var layerList = GetEntityItem1<ActiveLayer>();
            var activeLayer = layerList.active;

            var siblingIndex = activeLayer.transform.GetSiblingIndex();
            if (activeLayer &&  siblingIndex < layerList.transform.childCount)
                activeLayer.transform.SetSiblingIndex(siblingIndex + 1);
        }
    }
}
