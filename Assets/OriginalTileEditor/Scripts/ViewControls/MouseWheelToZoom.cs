using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseWheelToZoom : ECSSystem
{
    private void Update()
    {
        foreach (var entity in GetEntities<GlobalMouseScrollEvent, ViewZoom>())
        {
            var mouseScrollEvent = entity.Item1;
            var viewZoom = entity.Item2;

            viewZoom.zoom += mouseScrollEvent.scrollDelta.y * viewZoom.zoomRate;
        }
    }
}
