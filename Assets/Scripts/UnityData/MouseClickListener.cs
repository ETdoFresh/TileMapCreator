using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class MouseClickListener : ECSComponent, IPointerClickHandler
{
    public new Camera camera;
    public Vector3 clickPosition;
    
    public void OnPointerClick(PointerEventData eventData)
    {
        if (!camera) camera = Camera.main;
        
        clickPosition = eventData.position;
        
        var mouseClickEvent = gameObject.AddComponent<MouseClickEvent>();
        mouseClickEvent.camera = camera;
        mouseClickEvent.mouseScreenPosition = eventData.position;
        mouseClickEvent.mouseWorldPosition = camera.ScreenToWorldPoint(eventData.position);
        EcsEventManager.Add(mouseClickEvent);
    }
}
