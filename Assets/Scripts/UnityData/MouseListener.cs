using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class MouseListener : ECSComponent, IPointerClickHandler, IPointerDownHandler, IPointerEnterHandler
{
    public new Camera camera;
    public Vector3 clickPosition;

    public void OnPointerClick(PointerEventData eventData) => LaunchFunction<MouseClickEvent>(eventData);
    public void OnPointerDown(PointerEventData eventData) => LaunchFunction<MouseDownEvent>(eventData);
    public void OnPointerEnter(PointerEventData eventData) => LaunchFunction<MouseEnterEvent>(eventData);

    private void LaunchFunction<T>(PointerEventData eventData) where T : MouseEvent
    {
        if (!camera) camera = Camera.main;

        clickPosition = eventData.position;
        
        var mouseEvent = gameObject.AddComponent<T>();
        mouseEvent.camera = camera;
        mouseEvent.mouseScreenPosition = eventData.position;
        mouseEvent.mouseWorldPosition = camera.ScreenToWorldPoint(eventData.position);
        mouseEvent.clickedGameObject = eventData.pointerPress;
        EcsEventManager.Add(mouseEvent);
    }
}