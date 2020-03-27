using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EnableDisableLayers : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<LayerList>())
        {
            var layerList = entity.Item1;
            foreach (var layer in layerList.layers)
            {
                var toggle = layer.GetComponentInChildren<Toggle>();
                layer.enabled = toggle && toggle.isOn;
            }
        }
    }
}
