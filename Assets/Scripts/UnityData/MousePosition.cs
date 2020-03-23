using UnityEngine;

public class MousePosition : ECSComponent
{
    public bool forceZZero = true;
    public new Camera camera;
    public Vector3 position;

    private void Update()
    {
        if (camera)
        {
            var mousePosition = Input.mousePosition;
            position = camera.ScreenToWorldPoint(mousePosition);
            if (forceZZero) position.z = 0;
        }
    }
}
