using UnityEngine;

public class MousePosition : ECSComponent
{
    public bool forceZZero = true;
    public new Camera camera;
    public Vector3 screenPosition;
    public Vector3 worldPosition;

    private void Update()
    {
        if (camera)
        {
            screenPosition = Input.mousePosition;
            worldPosition = camera.ScreenToWorldPoint(screenPosition);
            if (forceZZero) worldPosition.z = 0;
        }
    }
}
