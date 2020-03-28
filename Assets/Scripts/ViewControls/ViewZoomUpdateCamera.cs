using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViewZoomUpdateCamera : ECSSystem
{
    private void Update()
    {
        foreach (var viewZoom in GetEntitiesItem1<ViewZoom>())
        {
            viewZoom.zoom = Mathf.Clamp(viewZoom.zoom, 0.000001f, 1000);
            var viewZoom2CameraSize = 5f;
            viewZoom2CameraSize /= viewZoom.zoom;
            viewZoom.camera.orthographicSize = viewZoom2CameraSize;
        }
    }
}
