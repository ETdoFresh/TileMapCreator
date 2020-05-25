using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EnableDisableLayers : ECSSystem
{
    private void Update()
    {
        foreach (var layer in GetEntitiesItem1<Layer>(true))
        {
            var wasEnabled = layer.enabled;
            var toggle = layer.GetComponentInChildren<Toggle>();
            layer.enabled = toggle && toggle.isOn;

            if (!wasEnabled && layer.enabled)
                GetEntityItem1<ActiveLayer>().active = layer;
        }
    }
}