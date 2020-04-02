using UnityEngine;

// TODO: Zoom in to pointer, not center of screen

[RequireComponent(typeof(Camera))]
public class ViewZoom : ECSComponent
{
    public new Camera camera;
    public float zoom = 1;
    public float zoomRate = 0.01f;

    private void OnValidate()
    {
        if (!camera) camera = GetComponent<Camera>();
    }
}
