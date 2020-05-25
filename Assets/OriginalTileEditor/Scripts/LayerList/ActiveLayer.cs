using System.Collections.Generic;
using UnityEngine;

// TODO: Export layers to CSV

public class ActiveLayer : ECSComponent
{
    public Color inactiveColor = Color.white;
    public Color activeColor = Color.yellow;
    public Layer active;
}