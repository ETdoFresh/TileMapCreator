using UnityEngine;

public class LaunchMouseEventSystem : ECSSystem
{
    private void Update()
    {
        var mousePosition = GetEntityItem1<MousePosition>();
        foreach (var globalMouseDownEvent in GetEntitiesItem1<GlobalMouseDownEvent>())
        foreach (var mouseDownListener in GetEntitiesItem1<MouseDownListener>())
            if (Contains(mouseDownListener.gameObject, mousePosition))
                LaunchEvent<MouseDownEvent>(mouseDownListener.gameObject, mousePosition);

        foreach (var globalMouseUpEvent in GetEntitiesItem1<GlobalMouseUpEvent>())
        foreach (var mouseUpListener in GetEntitiesItem1<MouseUpListener>())
            if (Contains(mouseUpListener.gameObject, mousePosition))
                LaunchEvent<MouseUpEvent>(mouseUpListener.gameObject, mousePosition);


        foreach (var mouseEnterListener in GetEntitiesItem1<MouseEnterListener>())
        {
            if (Contains(mouseEnterListener.gameObject, mousePosition))
            {
                if (!mouseEnterListener.previouslyInObject)
                    LaunchEvent<MouseEnterEvent>(mouseEnterListener.gameObject, mousePosition);
                mouseEnterListener.previouslyInObject = true;
            }
            else
            {
                mouseEnterListener.previouslyInObject = false;
            }
        }

        foreach (var mouseExitListener in GetEntitiesItem1<MouseExitListener>())
        {
            if (Contains(mouseExitListener.gameObject, mousePosition))
            {
                mouseExitListener.previouslyInObject = true;
            }
            else
            {
                if (mouseExitListener.previouslyInObject)
                    LaunchEvent<MouseExitEvent>(mouseExitListener.gameObject, mousePosition);
                mouseExitListener.previouslyInObject = false;
            }
        }
    }

    private bool Contains(GameObject gameObject, MousePosition mousePosition)
    {
        var collider = gameObject.GetComponent<Collider2D>();
        if (collider)
            if (collider.bounds.Contains(mousePosition.worldPosition))
                return true;

        var rectTransform = gameObject.GetComponent<RectTransform>();
        if (rectTransform)
        {
            var corners = new Vector3[4];
            rectTransform.GetWorldCorners(corners);
            var position = corners[0];
            var size = corners[2] - corners[0];
            var rect = new Rect(position, size);
            if (rect.Contains(mousePosition.screenPosition))
                return true;
        }

        return false;
    }

    private static void LaunchEvent<T>(GameObject gameObject, T mouseEvent)
        where T : MouseEvent
        => LaunchEvent<T>(gameObject, mouseEvent.camera, mouseEvent.mouseScreenPosition, mouseEvent.mouseWorldPosition);

    private static void LaunchEvent<T>(GameObject gameObject, MousePosition mousePosition)
        where T : MouseEvent
        => LaunchEvent<T>(gameObject, mousePosition.camera, mousePosition.screenPosition, mousePosition.worldPosition);

    private static void LaunchEvent<T>(GameObject gameObject, Camera camera, Vector3 screenPosition,
        Vector3 worldPosition)
        where T : MouseEvent
    {
        var ev = gameObject.AddComponent<T>();
        ev.camera = camera;
        ev.mouseScreenPosition = screenPosition;
        ev.mouseWorldPosition = worldPosition;
        EcsEventManager.Add(ev);
    }
}