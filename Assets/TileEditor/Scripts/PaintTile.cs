using System.Collections;
using System.Collections.Generic;
using TileEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Tilemaps;

public class PaintTile : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler
{
    public SelectedLayer selectedLayer;
    public new SmoothCamera smoothCamera;
    public Vector3 pointerStartPosition;
    public Vector3 cameraStartPosition;
    public Vector3 position;
    public bool updateScaleOnDrag = false;
    public float scaleMultiplier;
    public Tilemap tilemap;
    public Tile tile;

    public void OnBeginDrag(PointerEventData eventData)
    {
        if (eventData.button == PointerEventData.InputButton.Middle)
        {
            cameraStartPosition = smoothCamera.transform.position;
            if (updateScaleOnDrag)
            {
                var viewBL = smoothCamera.camera.ViewportToWorldPoint(Vector3.zero).x;
                var viewTR = smoothCamera.camera.ViewportToWorldPoint(Vector3.one).x;
                var worldDelta = viewTR - viewBL;
                viewBL = smoothCamera.camera.ViewportToScreenPoint(Vector3.zero).x;
                viewTR = smoothCamera.camera.ViewportToScreenPoint(Vector3.one).x;
                var screenDelta = viewTR - viewBL;
                scaleMultiplier = worldDelta / screenDelta;
            }
        }
    }

    public void OnDrag(PointerEventData eventData)
    {
        if (eventData.button == PointerEventData.InputButton.Left)
        {
            var current = eventData.pointerCurrentRaycast;
            if (current.gameObject == gameObject)
            {
                var x = Mathf.FloorToInt(current.worldPosition.x);
                var y = Mathf.FloorToInt(current.worldPosition.y);
                var position = new Vector3Int(x, y, 0);
                selectedLayer.tilemap.SetTile(position, tile);
            }
        }
        else if (eventData.button == PointerEventData.InputButton.Right)
        {
            var current = eventData.pointerCurrentRaycast;
            if (current.gameObject == gameObject)
            {
                var x = Mathf.FloorToInt(current.worldPosition.x);
                var y = Mathf.FloorToInt(current.worldPosition.y);
                var position = new Vector3Int(x, y, 0);
                selectedLayer.tilemap.SetTile(position, null);
            }
        }
        else
        {
            pointerStartPosition = eventData.pointerPressRaycast.screenPosition;
            position = eventData.pointerCurrentRaycast.screenPosition;
            var delta = position - pointerStartPosition;
            delta *= scaleMultiplier;
            smoothCamera.targetPosition = cameraStartPosition - delta;
        }
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        if (eventData.button == PointerEventData.InputButton.Middle)
            cameraStartPosition = Vector3.zero;
    }
}