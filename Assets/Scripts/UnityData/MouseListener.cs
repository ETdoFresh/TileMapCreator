using UnityEngine;
using UnityEngine.EventSystems;

// TODO: Investigate why clicking causes tons of CPU usage
// TODO: Maybe seperate this out to each individual event

public class MouseListener : ECSComponent, IPointerClickHandler, IPointerDownHandler, IPointerEnterHandler
{
    public new Camera camera;
    public Vector3 clickPosition;

    public void OnPointerClick(PointerEventData eventData) => LaunchFunction<MouseClickEvent>(eventData);
    public void OnPointerDown(PointerEventData eventData) => LaunchFunction<MouseDownEvent>(eventData);
    public void OnPointerEnter(PointerEventData eventData) => LaunchFunction<MouseEnterEvent>(eventData);

    private MouseEvent LaunchFunction<T>(PointerEventData eventData) where T : MouseEvent
    {
        if (!camera) camera = Camera.main;

        clickPosition = eventData.position;
        
        var mouseEvent = gameObject.AddComponent<T>();
        mouseEvent.camera = camera;
        mouseEvent.mouseScreenPosition = eventData.position;
        mouseEvent.mouseWorldPosition = camera.ScreenToWorldPoint(eventData.position);
        mouseEvent.clickedGameObject = eventData.pointerPress;
        EcsEventManager.Add(mouseEvent);
        return mouseEvent;
    }
    
    private T LaunchFunction<T>() where T : MouseEvent
    {
        if (!camera) camera = Camera.main;

        clickPosition = Input.mousePosition;
        
        var mouseEvent = gameObject.AddComponent<T>();
        mouseEvent.camera = camera;
        mouseEvent.mouseScreenPosition = clickPosition;
        mouseEvent.mouseWorldPosition = camera.ScreenToWorldPoint(clickPosition);
        mouseEvent.clickedGameObject = null;
        EcsEventManager.Add(mouseEvent);
        return mouseEvent;
    }

    private void Update()
    {
        if (Input.mouseScrollDelta != Vector2.zero)
        {
            var mouseScrollEvent = LaunchFunction<MouseScrollEvent>();
            mouseScrollEvent.scrollDelta = Input.mouseScrollDelta;
        }

        if (Input.GetMouseButtonDown(0))
            LaunchFunction<GlobalMouseDownEvent>();
        
        if (Input.GetMouseButtonUp(0))
            LaunchFunction<GlobalMouseUpEvent>();
    }
}