using System;
using UnityEngine;

public class SmoothCamera : MonoBehaviour
{
    public new Camera camera;
    public float acceleration = 15;
    public Vector3 targetPosition;
    public float targetOrthographicSize;

    private void OnEnable()
    {
        targetPosition = camera.transform.position;
        targetOrthographicSize = camera.orthographicSize;
    }

    private void Update()
    {
        if (targetPosition != camera.transform.position)
        {
            var cameraPosition = this.camera.transform.position;
            targetPosition.z = cameraPosition.z;
            var velocity = acceleration * Time.deltaTime;
            camera.transform.position = Vector3.Lerp(cameraPosition, targetPosition, velocity);
        }

        const float TOLERANCE = 0.001f;
        if (Math.Abs(targetOrthographicSize - camera.orthographicSize) > TOLERANCE)
        {
            var orthographicSize = camera.orthographicSize;
            var velocity = acceleration * Time.deltaTime;
            camera.orthographicSize = Mathf.Lerp(orthographicSize, targetOrthographicSize, velocity);
        }
    }
}
