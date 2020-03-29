using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

public class ViewPanUpdate : ECSSystem
{
    private void Update()
    {
        foreach(var entity in GetEntities<Background, MouseDownEvent>())
        {
            continue;
        }
        
        foreach (var entity in GetEntities<ViewPan, GlobalMouseDownEvent>())
        {
            var viewPan = entity.Item1;
            var mouseDownEvent = entity.Item2;
            viewPan.isDragging = true;
            viewPan.startMousePosition = mouseDownEvent.mouseScreenPosition;
            viewPan.startCameraPosition = viewPan.transform.position;
        }

        foreach (var viewPan in GetEntitiesItem1<ViewPan, GlobalMouseUpEvent>())
            viewPan.isDragging = false;

        foreach (var viewPan in GetEntitiesItem1<ViewPan>())
        {
            if (viewPan.isDragging)
            {
                var mousePosition = GetEntityItem1<MousePosition>();
                var delta = mousePosition.camera.ScreenToWorldPoint(viewPan.startMousePosition);
                delta -= mousePosition.worldPosition;
                delta.z = 0;
                viewPan.position = viewPan.startCameraPosition + delta;
                viewPan.transform.position = viewPan.position;
            }
        }
    }
}