using UnityEngine;

public class ViewPan : ECSComponent
{
    public bool isDragging;
    public Vector3 startCameraPosition;
    public Vector3 startMousePosition;
    public Vector3 position;
    public Vector3 delta;
}