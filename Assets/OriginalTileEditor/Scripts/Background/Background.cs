using UnityEngine;

public class Background : ECSComponent
{
    public float viewWorldLeftBorder;
    public float viewWorldRightBorder;
    public float viewWorldTopBorder;
    public float viewWorldBottomBorder;
    
    public Vector2 screenSize;
    public Vector2 worldSize;
}