using UnityEngine;

public abstract class MouseEvent : ECSEvent
{
    public new Camera camera;
    public Vector3 mouseScreenPosition;
    public Vector3 mouseWorldPosition;
    public GameObject clickedGameObject;
}