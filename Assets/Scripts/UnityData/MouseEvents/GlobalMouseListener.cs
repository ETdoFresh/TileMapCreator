using UnityEngine;
using UnityEngine.UI;

public class GlobalMouseListener : MonoBehaviour
{
    public new Camera camera;
    
    private void Update()
    {
        if (!camera) camera = Camera.main;
        
        if (Input.GetMouseButtonDown(0))
            LaunchEvent<GlobalMouseDownEvent>();

        if (Input.GetMouseButtonUp(0))
            LaunchEvent<GlobalMouseUpEvent>();

        if (Input.mouseScrollDelta != Vector2.zero)
        {
            var ev = LaunchEvent<GlobalMouseScrollEvent>();
            ev.scrollDelta = Input.mouseScrollDelta;
        }
    }

    private T LaunchEvent<T>() where T : MouseEvent
    {
        var ev = gameObject.AddComponent<T>();
        ev.camera = camera;
        ev.mouseScreenPosition = Input.mousePosition;
        ev.mouseWorldPosition = camera.ScreenToWorldPoint(ev.mouseScreenPosition);
        EcsEventManager.Add(ev);
        return ev;
    }
}