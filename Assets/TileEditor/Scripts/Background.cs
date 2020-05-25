using System;
using UnityEngine;
using UnityEngine.EventSystems;

namespace TileEditor
{
    public class Background : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler
    {
        public new SmoothCamera smoothCamera;
        public Vector3 pointerStartPosition;
        public Vector3 cameraStartPosition;
        public Vector3 position;
        public bool updateScaleOnDrag = false;
        public float scaleMultiplier;

        public void OnBeginDrag(PointerEventData eventData)
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

        public void OnDrag(PointerEventData eventData)
        {
            pointerStartPosition = eventData.pointerPressRaycast.screenPosition;
            position = eventData.pointerCurrentRaycast.screenPosition;
            var delta = position - pointerStartPosition;
            delta *= scaleMultiplier;
            smoothCamera.targetPosition = cameraStartPosition - delta;
        }

        public void OnEndDrag(PointerEventData eventData)
        {
            cameraStartPosition = Vector3.zero;
        }

        private void Update()
        {
            const float TOLERANCE = 0.001f;
            if (Input.mouseScrollDelta.y < -TOLERANCE)
            {
                var worldPosition = smoothCamera.camera.ScreenToWorldPoint(Input.mousePosition);
                var delta = worldPosition - smoothCamera.targetPosition;
                smoothCamera.targetPosition -= delta;
                smoothCamera.targetOrthographicSize *= 2;
            }
            else if (Input.mouseScrollDelta.y > TOLERANCE)
            {
                var worldPosition = smoothCamera.camera.ScreenToWorldPoint(Input.mousePosition);
                var delta = worldPosition - smoothCamera.targetPosition;
                smoothCamera.targetPosition += delta / 2;
                smoothCamera.targetOrthographicSize /= 2;
            }
        }
    }
}