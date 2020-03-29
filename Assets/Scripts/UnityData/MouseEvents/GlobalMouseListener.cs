using UnityEngine;

public class GlobalMouseListener : MonoBehaviour
{
    public new Camera camera;
    
    private void Update()
    {
        if (!camera) camera = Camera.main;
        
        if (Input.GetMouseButtonDown(0))
        {
            var ev = gameObject.AddComponent<GlobalMouseDownEvent>();
            ev.camera = camera;
            ev.mouseScreenPosition = Input.mousePosition;
            ev.mouseWorldPosition = camera.ScreenToWorldPoint(ev.mouseScreenPosition);
            EcsEventManager.Add(ev);
        }
        
        if (Input.GetMouseButtonUp(0))
        {
            var ev = gameObject.AddComponent<GlobalMouseUpEvent>();
            ev.camera = camera;
            ev.mouseScreenPosition = Input.mousePosition;
            ev.mouseWorldPosition = camera.ScreenToWorldPoint(ev.mouseScreenPosition);
            EcsEventManager.Add(ev);
        }
    }
}