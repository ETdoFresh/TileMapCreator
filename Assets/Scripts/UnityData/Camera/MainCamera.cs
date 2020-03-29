using UnityEngine;

public class MainCamera : ECSComponent
{
    public new Camera camera;

    private void Update()
    {
        if (!camera) camera = Camera.main;
    }
}
