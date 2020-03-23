using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseClickEvent : ECSEvent
{
    public new Camera camera;
    public Vector3 mouseScreenPosition;
    public Vector3 mouseWorldPosition;
}
